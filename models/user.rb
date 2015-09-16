class User < Sequel::Model
  plugin :secure_password
  plugin :validation_helpers
  plugin :association_dependencies
  self.raise_on_save_failure = false

  one_to_many :posts
  add_association_dependencies posts: :destroy

  def validate
    super
    validates_unique %i(username)
    validates_presence %i(username)
  end
end
