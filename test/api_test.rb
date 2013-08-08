require './test/test_helper'
require 'rack/test'
require './lib/api'

class APITest < Minitest::Test
  include Rack::Test::Methods
  include WithRollback

  def app
    API
  end

  def test_it_exists
    get '/'
    assert_equal 200, last_response.status
  end

  def test_it_returns_an_existing_rating
    temporarily do
      rating = Opinions::Rating.create(:product_id => 1, :user_id => 2, :stars => 3)
      get '/products/1/ratings/2'
      response = JSON.parse(last_response.body)
      assert_equal 1, response["rating"]["product_id"]
      assert_equal 2, response["rating"]["user_id"]
      assert_equal 3, response["rating"]["stars"]
    end
  end

  def test_it_returns_all_ratings_for_a_product
    temporarily do
      2.times{|i| Opinions::Rating.create(:product_id => 1, :user_id => i, :stars => 3) }
      non_matching = Opinions::Rating.create(:product_id => 2, :user_id => 0, :stars => 3)

      get '/products/1/ratings'
      response = JSON.parse(last_response.body)["ratings"]
      response.each do |rating|
        assert_equal 1, rating["rating"]["product_id"]
      end
      assert_equal 2, response.size
    end
  end

  def test_it_returns_all_ratings_for_a_user
    temporarily do
      2.times{|i| Opinions::Rating.create(:product_id => i, :user_id => 1, :stars => 3) }
      non_matching = Opinions::Rating.create(:product_id => 0, :user_id => 2, :stars => 3)

      get '/users/1/ratings'
      response = JSON.parse(last_response.body)["ratings"]
      response.each do |rating|
        assert_equal 1, rating["rating"]["user_id"]
      end
      assert_equal 2, response.size
    end
  end

end