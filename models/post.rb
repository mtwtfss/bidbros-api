class Post < Sequel::Model
  plugin :validation_helpers
  plugin :association_dependencies
  self.raise_on_save_failure = false

  many_to_one :user

  def validate
    super
    validates_presence %i(user_id title url)
  end
end
