require 'bundler'
Bundler.require

module Opinions

  def self.env
    ENV['OPINIONS_ENV'] || "development"
  end

  class Config

  end
end

ActiveRecord::Base.establish_connection( YAML.load(File.read("./config/database.yml"))[Opinions.env] ) 