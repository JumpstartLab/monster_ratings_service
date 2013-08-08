gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

ENV['OPINIONS_ENV'] = 'test'
require './config/environment'
require './lib/opinions'

module WithRollback
  def temporarily(&block)
    ActiveRecord::Base.transaction do
      block.call
      raise ActiveRecord::Rollback
    end
  end
end