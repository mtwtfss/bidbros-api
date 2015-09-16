module Resource
  class Post
    attr_reader :options

    def initialize(options)
      @options = options.symbolize_keys
    end

    def render
      post = ::Post[options[:id]]
      if post
        post = post.values
        post[:created_at] = post[:created_at].to_i
        post[:updated_at] = post[:updated_at].to_i
        { status: 200, data: post }
      end
    end

    def render_set
      { status: 200, data: format(::Post.reverse(:id).all) }
    end

    def format(posts)
      posts.map do |post|
        post[:created_at] = post[:created_at].to_i
        post[:updated_at] = post[:updated_at].to_i
        post.to_hash
      end
    end

    def create
      post = ::Post.new
      if set_attrs(post, options)
        { status: 201, data: post.values }
      else
        { status: 422, errors: post.errors.full_messages }
      end
    end

    def update
      post = ::Post[options[:id]]
      if post.user_id == options[:user_id].to_i
        if set_attrs(post, options)
          { status: 200, data: post.values }
        else
          { status: 422, errors: post.errors.full_messages }
        end
      else
        throw 403
      end
    end

    def delete
      post = ::Post[options[:id]]
      if post.user_id == options[:user_id].to_i
        post.destroy
      else
        throw 403
      end
    end

    def set_attrs(post, attrs)
      attrs.each do |k, v|
        post[k] = v if updatable_fields.include? k.to_s
      end
      post.save
    end

    def updatable_fields
      %w(title url user_id)
    end
  end
end
