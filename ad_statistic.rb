class AdStatistic
  include DataMapper::Resource

  property :ad_id, Integer, key: true
  property :date, Date, key: true
  property :impressions, Integer, min: 0, max: 2**32
  property :clicks, Integer, min: 0, max: 2**32
  property :spent, Integer, min: 0, max: 2**32
end