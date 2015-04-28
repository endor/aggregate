require 'spec_helper'
require_relative '../api'

describe 'API' do
  it 'responds with a 200 status code' do
    get('/api/stats')
    expect(last_response.status).to eql 200
  end

  it 'collects ad statistics and actions for given ids and time frame' do
    get('/api/stats?ad_ids=1,2&start_time=2013-09-26&end_time=2013-09-28')

    expect(JSON.parse(last_response.body)).to eql ({
      '1' => {
        'impressions' => 1324861, # Sum of impressions
        'clicks' => 19100,        # Sum of clicks
        'spent' => 2386,          # Sum of spent
        'ctr' => 0.0144,          # Click-through-rate
        'cpc' => 0.1249,           # Cost per click
        'cpm' => 1.8009,           # Cost per 1000 impressions
        'actions' => {
          'link_click' => {
            'count' => 249,       # Sum of actions
            'value' => 0,         # Sum of action values
            'cpa' => 0            # Cost per action
          }
        }
      },
      '2' => {
        'impressions' => 1817553,
        'clicks' => 24281,
        'spent' => 1389,
        'ctr' => 0.0134,
        'cpc' => 0.0572,
        'cpm' => 0.7642,
        'actions' => {
          'page_like' => {
            'count' => 151,
            'value' => 0,
            'cpa' => 0
          },
          'video_view' => {
            'count' => 223,
            'value' => 0,
            'cpa' => 0
          }
        }
      }
      })
  end
end