class Listing < Sequel::Model
  plugin :validation_helpers
  plugin :association_dependencies
  self.raise_on_save_failure = false

  many_to_one :seller

  def validate
    super
    validates_presence %i(seller_id listing_id)
    validates_unique :listing_id
  end
end
