module Opinions
  class Rating < ActiveRecord::Base
    validates_presence_of :stars, :user_id, :product_id, :title, :body
    validates_inclusion_of :stars, :in => 0..5

    def self.find_unique(product_id, user_id)
      self.where(:product_id => product_id, :user_id => user_id).first
    end
  end
end