require 'sinatra/base'

module Sinatra
  module Authentication
    module Helpers
      def warden
        env['warden']
      end

      def current_user
        warden.user
      end

      def auth_check(id = nil)
        halt 401 if current_user.nil?
        halt 403 if current_user.id != (id || params[:user_id].to_i)
      end
    end

    def self.registered(app)
      app.helpers Authentication::Helpers
    end
  end

  register Authentication
end
