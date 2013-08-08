require './test/test_helper'

class OpinionsTest < Minitest::Test
  def teardown
    ENV['OPINIONS_ENV'] = "test"
  end

  def test_it_exists
    assert Opinions
  end

  def test_environment
    assert_equal 'test', Opinions.env
  end

  def test_environment_is_controlled_by_system_varaiables
    ENV['OPINIONS_ENV'] = "production"
    assert_equal "production", Opinions.env
  end

  def test_environment_defaults_to_dev
    ENV.delete('OPINIONS_ENV')
    assert_equal "development", Opinions.env
  end
end