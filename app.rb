require 'sinatra'

class BidBros < Sinatra::Application
  configure do
    require File.expand_path(File.join(*%w[config environment]), File.dirname(__FILE__))
  end
end
