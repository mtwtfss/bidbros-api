class Bid < Sequel::Model
  plugin :validation_helpers
  plugin :association_dependencies
  self.raise_on_save_failure = false

  many_to_one :agent
  many_to_one :listing

  def validate
    super
    validates_presence %i(listing_id accepted agent_id close_price duration commission)
    validates_unique(:listing_id) { |bids| bids.where(accepted: 1) }
  end
end
