require 'spec_helper'
require_relative '../api'

describe 'API' do
  it 'responds with a 200 status code' do
    get('/api/stats')
    expect(last_response.status).to eql 200
  end


#<AdStatistic @ad_id=1 @impressions=176159 @clicks=3858 @spent=324>,
#<AdStatistic @ad_id=1 @impressions=894519 @clicks=14581 @spent=1673>,
#<AdStatistic @ad_id=1 @impressions=254183 @clicks=661 @spent=389>

#<AdStatistic @ad_id=2 @impressions=678401 @clicks=12550 @spent=360>,
#<AdStatistic @ad_id=2 @impressions=276463 @clicks=5778 @spent=235>,
#<AdStatistic @ad_id=2 @impressions=862689 @clicks=5953 @spent=794>

#<AdAction @ad_id=1 @date=#<Date: 2013-09-26 ((2456562j,0s,0n),+0s,2299161j)> @action="link_click" @count=50 @value=0>,
#<AdAction @ad_id=1 @date=#<Date: 2013-09-27 ((2456563j,0s,0n),+0s,2299161j)> @action="link_click" @count=190 @value=0>,
#<AdAction @ad_id=1 @date=#<Date: 2013-09-28 ((2456564j,0s,0n),+0s,2299161j)> @action="link_click" @count=9 @value=0>

#<AdAction @ad_id=2 @date=#<Date: 2013-09-26 ((2456562j,0s,0n),+0s,2299161j)> @action="page_like" @count=63 @value=0>,
#<AdAction @ad_id=2 @date=#<Date: 2013-09-26 ((2456562j,0s,0n),+0s,2299161j)> @action="video_view" @count=100 @value=0>,
#<AdAction @ad_id=2 @date=#<Date: 2013-09-27 ((2456563j,0s,0n),+0s,2299161j)> @action="page_like" @count=58 @value=0>,
#<AdAction @ad_id=2 @date=#<Date: 2013-09-27 ((2456563j,0s,0n),+0s,2299161j)> @action="video_view" @count=46 @value=0>,
#<AdAction @ad_id=2 @date=#<Date: 2013-09-28 ((2456564j,0s,0n),+0s,2299161j)> @action="page_like" @count=30 @value=0>,
#<AdAction @ad_id=2 @date=#<Date: 2013-09-28 ((2456564j,0s,0n),+0s,2299161j)> @action="video_view" @count=77 @value=0>


  it 'collects ad statistics and actions for given ids and time frame' do
    get('/api/stats?ad_ids=1,2&start_time=2013-09-26&end_time=2013-09-28')
    expect(last_response.status).to eql {
      '1': {
        'impressions': 1324861, # Sum of impressions
        'clicks': 19100,        # Sum of clicks
        'spent': 2386,          # Sum of spent
        'ctr': 0.0534,          # Click-through-rate
        'cpc': 80,              # Cost per click
        'cpm': 120,             # Cost per 1000 impressions
        'actions': {
          'mobile_app_install': {
            'count': 50,        # Sum of actions
            'value': 3900,      # Sum of action values
            'cpa': 520          # Cost per action
          },
          'page_like': {
            'count': 4,
            'value': 0,
            'cpa': 412
          }
        }
      },
      '2': {
        'impressions': 1817553,
        'clicks': 924,
        'spent': 51242,
        'ctr': 0.0084,
        'cpc': 30,
        'cpm': 340,
        'actions': {}
      }
    }
  end
end