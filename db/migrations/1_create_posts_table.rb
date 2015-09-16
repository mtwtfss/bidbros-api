Sequel.migration do
  up do
    create_table :posts do
      primary_key :id
      Integer     :user_id, null: false
      String      :url, null: false
      String      :title, null: false
      DateTime    :created_at, null: false
      DateTime    :updated_at, null: false

      index :user_id
    end
  end

  down do
    drop_table :posts
  end
end
