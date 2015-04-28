require 'active_support/core_ext/enumerable'

class Statistics
  def self.calculate(options)
    ad_ids = options[:ad_ids].split(',').map(&:to_i) if options[:ad_ids]

    if ad_ids
      start_time = options[:start_time]
      end_time = options[:end_time]

      query_params = {ad_id: ad_ids}
      query_params[:date] = Date.parse(start_time)..Date.parse(end_time) if start_time && end_time

      ad_statistics = AdStatistic.all(query_params).group_by(&:ad_id)
      ad_actions = AdAction.all(query_params).group_by(&:ad_id)

      ad_statistics.inject({}) do |results, ad_statistics|
        id, ad_statistics_group = ad_statistics

        impressions = ad_statistics_group.sum(&:impressions)
        clicks = ad_statistics_group.sum(&:clicks)
        spent = ad_statistics_group.sum(&:spent)

        results[id.to_s] = {
          'impressions' => impressions,
          'clicks' => clicks,
          'spent' => spent,
          'ctr' => (clicks.to_f/impressions.to_f).round(4),
          'cpc' => (spent.to_f/clicks.to_f).round(4),
          'cpm' => (spent.to_f/impressions.to_f*1000.0).round(4),
          'actions' => ad_actions[id].group_by(&:action).inject({}) do |action_results, ad_actions|
            action_results[ad_actions.first] = {
              'count' => ad_actions.last.sum(&:count),
              'value' => ad_actions.last.sum(&:value),
              'cpa' => 0
            }

            action_results
          end
        }

        results
      end
    else
      {}
    end
  end
end