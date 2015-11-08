module Resource
  class Listing
    attr_reader :options

    def initialize(options)
      @options = options.symbolize_keys
    end

    def render
      listing = ::Listing[options[:id]]
      if listing
        listing = listing.values
        listing[:created_at] = listing[:created_at].to_i
        listing[:updated_at] = listing[:updated_at].to_i
        { status: 200, data: listing }
      end
    end

    def render_set
      { status: 200, data: format(::Listing.reverse(:id).all) }
    end

    def format(listings)
      listings.map do |listing|
        listing[:created_at] = listing[:created_at].to_i
        listing[:updated_at] = listing[:updated_at].to_i
        listing.to_hash
      end
    end

    def create
      listing = ::Listing.new(options)
      if listing.save
        { status: 201, data: listing.values }
      else
        { status: 422, errors: listing.errors.full_messages }
      end
    end

    def set_attrs(listing, attrs)
      attrs.each do |k, v|
        listing[k] = v if updatable_fields.include? k.to_s
      end
      listing.save
    end
  end
end
