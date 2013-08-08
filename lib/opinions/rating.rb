module Opinions
  class Rating < ActiveRecord::Base

    def stars
      3
    end

    def self.find_unique(product_id, user_id)
      self.where(:product_id => product_id, :user_id => user_id).first
    end
  end
end