class Agent < Sequel::Model
  plugin :validation_helpers
  plugin :association_dependencies
  self.raise_on_save_failure = false

  one_to_many :bids

  def validate
    super
    validates_presence :agent_id
    validates_unique :agent_id
  end
end
