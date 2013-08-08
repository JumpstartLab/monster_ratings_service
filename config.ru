$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require

require './config/environment'
require 'opinions'
require 'api'

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run API