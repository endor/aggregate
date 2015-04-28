require 'active_support/core_ext/enumerable'

class Statistics
  def self.calculate(options)
    ad_ids = options[:ad_ids].split(',').map(&:to_i) if options[:ad_ids]

    if ad_ids
      start_time = options[:start_time]
      end_time = options[:end_time]

      statistics_query = 'SELECT ad_id, SUM(impressions) AS impressions, SUM(clicks) AS clicks, SUM(spent) AS spent FROM ad_statistics WHERE ad_id IN ? AND date BETWEEN ? AND ? GROUP BY ad_id'
      ad_statistics = repository(:default).adapter.select(statistics_query, ad_ids, start_time, end_time)

      actions_query = 'SELECT ad_id, action, SUM(count) AS count, SUM(value) AS value FROM ad_actions WHERE ad_id IN ? AND date BETWEEN ? AND ? GROUP BY ad_id, action'
      ad_actions = repository(:default).adapter.select(actions_query, ad_ids, start_time, end_time)

      ad_statistics.inject({}) do |results, aggregated_statistics|
        ad_id = aggregated_statistics.ad_id
        impressions = aggregated_statistics.impressions.to_i
        clicks = aggregated_statistics.clicks.to_i
        spent = aggregated_statistics.spent.to_i

        results[ad_id.to_s] = {
          'impressions' => impressions,
          'clicks' => clicks,
          'spent' => spent,
          'ctr' => (clicks.to_f/impressions.to_f).round(4),
          'cpc' => (spent.to_f/clicks.to_f).round(4),
          'cpm' => (spent.to_f/impressions.to_f*1000.0).round(4),
          'actions' => ad_actions.find_all{|a| a[:ad_id] == ad_id}.inject({}) do |actions, aggregated_actions|
            actions[aggregated_actions.action] = {
              'count' => aggregated_actions.count.to_i,
              'value' => aggregated_actions.value.to_i,
              'cpa' => 0
            }

            actions
          end
        }

        results
      end
    else
      {}
    end
  end
end