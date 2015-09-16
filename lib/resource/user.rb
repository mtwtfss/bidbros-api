module Resource
  class User
    attr_reader :options

    def initialize(options)
      @options = options.symbolize_keys
    end

    def render
      user = ::User[options[:id]]
      { status: 200, data: format(user) } if user
    end

    def render_set
      users = ::User.all.map { |user| format(user) }
      { status: 200, data: users }
    end

    def format(user)
      user = user.to_hash
      user.delete(:password_digest)
      user[:created_at] = user[:created_at].to_i
      user[:updated_at] = user[:updated_at].to_i
      user
    end

    def update
      user = ::User[options[:id]]
      if set_attrs(user, options.slice(updatable_fields))
        { status: 200, data: user.values }
      else
        { status: 422, errors: user.errors.full_messages }
      end
    end

    def create
      user = ::User.new
      if set_attrs(user, options)
        { status: 201, data: user.values }
      else
        { status: 422, errors: user.errors.full_messages }
      end
    end

    def set_attrs(user, attrs)
      attrs.each do |k, v|
        user[k.to_sym] = v if updatable_fields.include? k
      end
      user.save
    end

    def updatable_fields
      %w(username password password_confirmation)
    end
  end
end
