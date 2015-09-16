# Sinatra Template

## About

This is a template for Sinatra applications.

## Setup

1. Install Homebrew
    + `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

1. Install RVM
    + `\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.2.2`
    + `rvm use 2.2.2 --default`
    + `rvm gemset create sinatra-template`
    + `rvm use 2.2.2@sinatra-template --default`

1.  Install Postgres
    + `brew install postgresql`
    + Follow the below post install steps for postgres:
        + To have launchd start postgres at login:
            + `ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents`
        + Then to load postgres now:
            + `launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist`

1.  Change the username in `config/db.yml` to your username

1. `gem install bundler`

1. `bundle install`

1.  Create the Postgres databases
    + `bundle exec rake db:create`
    + `bundle exec rake db:create RACK_ENV=test`

1.  Run the database migrations
    + `bundle exec rake db:migrate`
    + `bundle exec rake db:migrate RACK_ENV=test`

## Running the server

1. `bundle exec rackup`
    + This will start the server on port 9292 by default

## Running the console

1. `bundle exec rake console`
