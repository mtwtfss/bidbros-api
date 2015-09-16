settings = YAML.load_file('config/db.yml')
set :database, settings[Sinatra::Base.environment.to_s]
