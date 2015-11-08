module Resource
  class Bid
    attr_reader :options

    def initialize(options)
      @options = options.symbolize_keys
    end

    def render
      bid = ::Bid[options[:id]]
      if bid
        bid = bid.values
        bid[:created_at] = bid[:created_at].to_i
        bid[:updated_at] = bid[:updated_at].to_i
        { status: 200, data: bid }
      end
    end

    def render_set
      { status: 200, data: format(bid_set.all) }
    end

    def bid_set
      listings = ::Seller[options[:seller_id]].listings
      listings.delete_if { |listing| listing.bids.select { |bid| bid.accepted == 1 }.any? }
      ::Bid
        .where(accepted: 0)
        .where(listing_id: listings.map(&:id).uniq)
    end

    def format(bids)
      bids.map do |bid|
        bid[:agent] = Agent.new(id: bid.agent_id).render[:data]
        bid[:created_at] = bid[:created_at].to_i
        bid[:updated_at] = bid[:updated_at].to_i
        bid.to_hash
      end
    end

    def create
      bid = ::Bid.new(options.merge(accepted: 0))
      if bid.save
        { status: 201, data: bid.values }
      else
        { status: 422, errors: bid.errors.full_messages }
      end
    end

    def update
      bid = ::Bid[options[:id]]
      if options[:accepted].to_i == 1
        ::Bid.where(listing_id: bid.listing_id).update(accepted: -1)
      end
      bid.accepted = options[:accepted].to_i unless options[:accepted].nil?
      if bid.save
        { status: 200, data: bid.values }
      else
        { status: 422, errors: bid.errors.full_messages }
      end
    end

    def set_attrs(bid, attrs)
      attrs.each do |k, v|
        bid[k] = v if updatable_fields.include? k.to_s
      end
      bid.save
    end

    def updatable_fields
      %w(accepted)
    end
  end
end
