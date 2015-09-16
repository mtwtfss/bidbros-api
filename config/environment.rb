require 'rubygems'
require 'bundler'
Bundler.require

configure :development, :test do
  require 'pry'
end

configure :test do
  require 'rspec'
  require 'factory_girl'
  Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
end

Sequel::Model.plugin :timestamps, update_on_create: true

%w(config/initializers lib models).each do |load_path|
  glob_path = "#{settings.root}/#{load_path}/**/*.rb"
  Dir.glob(glob_path, &method(:require))
end
