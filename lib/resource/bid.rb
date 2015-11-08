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
      ::Bid
        .join(::Listing, id: :listing_id)
        .join(::Seller, id: :seller_id)
        .where('listings.seller_id = ?', options[:seller_id])
    end

    def format(bids)
      bids.map do |bid|
        bid[:created_at] = bid[:created_at].to_i
        bid[:updated_at] = bid[:updated_at].to_i
        bid.to_hash
      end
    end

    def create
      bid = ::Bid.new
      if set_attrs(bid, options)
        { status: 201, data: bid.values }
      else
        { status: 422, errors: bid.errors.full_messages }
      end
    end

    def update
      bid = ::Bid[options[:id]]
      if bid.user_id == options[:user_id].to_i
        if set_attrs(bid, options)
          { status: 200, data: bid.values }
        else
          { status: 422, errors: bid.errors.full_messages }
        end
      else
        throw 403
      end
    end

    def set_attrs(bid, attrs)
      attrs.each do |k, v|
        bid[k] = v if updatable_fields.include? k.to_s
      end
      bid.save
    end

    def updatable_fields
      %w(:accepted)
    end
  end
end
