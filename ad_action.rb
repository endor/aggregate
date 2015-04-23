class AdAction
  include DataMapper::Resource

  property :ad_id, Integer, key: true
  property :date, Date, key: true
  property :action, String, key: true
  property :count, Integer, min: 0, max: 2**32
  property :value, Integer, min: 0, max: 2**32
end