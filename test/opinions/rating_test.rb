require './test/test_helper'
require './lib/opinions/rating'

class RatingTest < Minitest::Test
  include WithRollback

  def test_it_exists
    assert Opinions::Rating
  end

  def test_it_has_stars
    rating = Opinions::Rating.new(stars: 3)
    assert_equal 3, rating.stars
  end

  def test_it_persists_a_rating
    temporarily do
      assert_equal 0, Opinions::Rating.count
      rating = Opinions::Rating.create(stars: 3)
      found = Opinions::Rating.find(rating.id)
      assert_equal 3, found.stars
    end
  end
end