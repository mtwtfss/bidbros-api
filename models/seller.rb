class Seller < Sequel::Model
  plugin :validation_helpers
  plugin :association_dependencies
  self.raise_on_save_failure = false

  one_to_many :listings

  def validate
    super
    validates_presence %i(full_name email phone)
    validates_unique :email
  end
end
