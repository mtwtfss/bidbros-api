module Resource
  class Seller
    attr_reader :options

    def initialize(options)
      @options = options.symbolize_keys
    end

    def render
      seller = ::Seller[options[:id]]
      if seller
        seller = seller.values
        seller[:created_at] = seller[:created_at].to_i
        seller[:updated_at] = seller[:updated_at].to_i
        { status: 200, data: seller }
      end
    end

    def render_set
      { status: 200, data: format(::Seller.reverse(:id).all) }
    end

    def format(sellers)
      sellers.map do |seller|
        seller[:created_at] = seller[:created_at].to_i
        seller[:updated_at] = seller[:updated_at].to_i
        seller.to_hash
      end
    end

    def create
      seller = ::Seller.new(options)
      if seller.save
        { status: 201, data: seller.values }
      else
        { status: 422, errors: seller.errors.full_messages }
      end
    end
  end
end
