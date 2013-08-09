require './test/test_helper'
require 'rack/test'
require './lib/api'

class APITest < Minitest::Test
  include Rack::Test::Methods
  include WithRollback

  def app
    API
  end

  def valid_data
    {"user_id" => 2, "product_id" => 3, 
     "stars" => 4, "title" => "the title",
     "body" => "the body"}
  end

  def test_it_exists
    get '/'
    assert_equal 200, last_response.status
  end

  def test_it_returns_an_existing_rating
    temporarily do
      rating = Opinions::Rating.create(valid_data)
      get "/products/#{ valid_data['product_id'] }/ratings/#{ valid_data['user_id'] }"
      response = JSON.parse(last_response.body)
      assert_equal valid_data["product_id"], response["rating"]["product_id"]
      assert_equal valid_data["user_id"], response["rating"]["user_id"]
      assert_equal valid_data["stars"], response["rating"]["stars"]
    end
  end

  def test_it_returns_all_ratings_for_a_product
    temporarily do
      2.times do |i|
        data = valid_data.merge({:user_id => i})
        Opinions::Rating.create(data)
      end

      non_matching_data = valid_data.merge({:product_id => 4})
      Opinions::Rating.create(non_matching_data)

      assert_equal 3, Opinions::Rating.count
      get "/products/#{ valid_data['product_id'] }/ratings"
      response = JSON.parse(last_response.body)["ratings"]
      response.each do |rating|
        assert_equal valid_data['product_id'], rating["rating"]["product_id"]
      end
      assert_equal 2, response.size
    end
  end

  def test_it_returns_all_ratings_for_a_user
    temporarily do
      2.times do |i|
        data = valid_data.merge({:product_id => i})
        Opinions::Rating.create(data)
      end

      non_matching_data = valid_data.merge({:user_id => 3})
      non_matching = Opinions::Rating.create(:product_id => 0, :user_id => 2, :stars => 3)

      get "/users/#{ valid_data['user_id'] }/ratings"
      response = JSON.parse(last_response.body)["ratings"]
      response.each do |rating|
        assert_equal valid_data['user_id'], rating["rating"]["user_id"]
      end
      assert_equal 2, response.size
    end
  end

  def test_it_writes_a_rating
    temporarily do
      data = {"user_id" => 2, "product_id" => 3, 
                "stars" => 4, "title" => "the title",
                "body" => "the body"}
      params = {"rating" => data}.to_json
      assert_equal 0, Opinions::Rating.count
      post "/products/#{params['product_id']}/ratings", params
      assert_equal 201, last_response.status
      rating = Opinions::Rating.first
      assert_equal data["user_id"], rating.user_id
      assert_equal data["product_id"], rating.product_id
      assert_equal data["stars"], rating.stars
      assert_equal data["title"], rating.title
      assert_equal data["body"], rating.body
    end
  end

  def test_it_fails_to_write_an_imcomplete_rating
    temporarily do
      mandatory_fields = valid_data.keys - ["product_id"]
      mandatory_fields.each do |target|
        data = valid_data.dup
        data[target] = nil
        params = {"rating" => data}.to_json
        assert_equal 0, Opinions::Rating.count
        post "/products/#{params['product_id']}/ratings", params
        assert_equal 400, last_response.status
        assert_equal 0, Opinions::Rating.count
      end
    end
  end

end