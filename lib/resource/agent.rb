module Resource
  class Agent
    attr_reader :options

    def initialize(options)
      @options = options.symbolize_keys
    end

    def render
      agent = ::Agent[options[:id]]
      if agent
        agent = agent.values
        agent[:created_at] = agent[:created_at].to_i
        agent[:updated_at] = agent[:updated_at].to_i
        { status: 200, data: agent }
      end
    end

    def render_set
      { status: 200, data: format(::Agent.reverse(:id).all) }
    end

    def format(agents)
      agents.map do |agent|
        agent[:created_at] = agent[:created_at].to_i
        agent[:updated_at] = agent[:updated_at].to_i
        agent.to_hash
      end
    end

    def create
      agent = ::Agent.new(options)
      if agent.save
        { status: 201, data: agent.values }
      else
        { status: 422, errors: agent.errors.full_messages }
      end
    end

    def update
      agent = ::Agent[options[:id]]
      if set_attrs(agent, options)
        { status: 200, data: agent.values }
      else
        { status: 422, errors: agent.errors.full_messages }
      end
    end

    def set_attrs(agent, attrs)
      attrs.each do |k, v|
        agent[k] = v if updatable_fields.include? k.to_s
      end
      agent.save
    end

    def updatable_fields
      %w(:yelp_url)
    end
  end
end
