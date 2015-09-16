use Rack::Session::Cookie, secret: ENV['SESSION_SECRET']

use Warden::Manager do |config|
  config.serialize_into_session { |user| user.id }
  config.serialize_from_session { |id| User[id] }

  config.failure_app = AuthenticationFailure.new
  config.scope_defaults :default, strategies: [:password]
end

Warden::Strategies.add(:password) do
  def authenticate!
    user = User.first(username: params['user']['username'])

    if user.nil?
      throw(:warden, error: 'User does not exist')
    elsif user.authenticate(params['user']['password'])
      success!(user)
    else
      throw(:warden, error: 'Incorrect password')
    end
  end
end

class AuthenticationFailure
  def call(env)
    error = env['warden.options'][:error] || 'Unauthorized'
    [401, {}, [error]]
  end
end
