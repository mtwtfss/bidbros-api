require 'json'
require 'spec_helper'

include Rack::Test::Methods
include Warden::Test::Helpers

describe 'routes' do
  let(:json_response) { JSON.parse(last_response.body)['data'] }
  let(:expected_response) do
    Post.reverse(:id).all.map do |post|
      {
        id: post.id,
        user_id: post.user_id,
        url: post.url,
        title: post.title,
        created_at: post.created_at.to_i,
        updated_at: post.updated_at.to_i
      }.stringify_keys
    end
  end

  describe 'GET /posts' do
    before(:each) { create_list :post, 5 }

    it 'returns all Posts' do
      get '/posts'

      expect(last_response).to be_ok
      expect(json_response).to eq(expected_response)
    end
  end
end
