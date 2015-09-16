require 'rake'

task :environment do
  load 'app.rb'
end

namespace :db do
  desc 'Create database'
  task create: :environment do
    conn = PG::Connection.open(
      host: database.opts[:host],
      port: database.opts[:port],
      user: database.opts[:user],
      password: database.opts[:password],
      dbname: 'template1'
    )
    conn.exec "CREATE DATABASE #{database.opts[:database]}"
    conn.close
  end

  desc "Migrate the database"
  task migrate: :environment do
    Sequel.extension :migration
    if ENV['version']
      puts "Migrating to version #{ENV['version']}"
      Sequel::Migrator.run(database, "db/migrations", target: ENV['version'].to_i)
    else
      puts 'Migrating to latest'
      Sequel::Migrator.run(database, 'db/migrations')
    end
  end
end

task console: :environment do
  require 'irb'
  ARGV.clear
  IRB.start
end
