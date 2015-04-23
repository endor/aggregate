require 'spec_helper'
require_relative '../api'

describe 'API' do
  it 'responds with a 200 status code' do
    get('/api/stats')
    expect(last_response.status).to eql 200
  end
end