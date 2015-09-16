require 'sinatra'

class SinatraTemplate < Sinatra::Application
  configure do
    require File.expand_path(File.join(*%w[config environment]), File.dirname(__FILE__))
  end
end
