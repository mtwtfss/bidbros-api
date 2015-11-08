module Resource
  class Agent
    attr_reader :options

    def initialize(options)
      @options = options.symbolize_keys
    end

    def render
      agent = ::Agent[options[:id]]
      { status: 200, data: agent.values.merge(agent_data(agent)) } if agent
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

    def access_token
      '07509b2d9cbbb03085b54a93a1afe935'
    end

    def agent_data(agent)
      uri = URI("https://rets.io/api/v1/armls/agents/#{agent.agent_id}/listings?access_token=#{access_token}")
      parsed_response = JSON.parse(Net::HTTP.get(uri))

      durations = profit_ranges = []
      listings = parsed_response["bundle"]["listings"]

      listings.to_a.each do |listing|
        durations.insert(listing['daysOnMarket'])
        profit_range = listing['closePrice'] - listing['originalPrice'] rescue next
        profit_ranges.insert(profit_range)
      end

      yelp_data = agent.yelp_url ? get_yelp_data(agent.yelp_url) : {}

      {
        name: parsed_response["bundle"]["fullName"],
        phone: parsed_response["bundle"]["cellPhone"],
        duration_min: durations.min,
        duration_max: durations.max,
        profit_range_min: profit_ranges.min,
        profit_range_max: profit_ranges.max,
        yelp_rating: yelp_data[:rating],
        review_count: yelp_data[:review_count]
      }
    end

    def yelp_creds
      {
        consumer_key: 'pxplEQIQRgOfyvvLHKNCJg',
        consumer_secret: '8xyAPmm8_7k8_ngPmeRIaF4y95g',
        token: 'cNfLdahb44BvCdFecO6sFvtAvAyjmtBh',
        token_secret: 'ORGO4iabK_6M9PG_DEyrezWQli0'
      }
    end

    def get_yelp_data(url)
      client = Yelp::Client.new(yelp_creds)
      response = client.business(url.split("/").last).business
      return {} if response.nil?
      {
        rating: response.rating,
        review_count: response.review_count
      }
    end
  end
end
