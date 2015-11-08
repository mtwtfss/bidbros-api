Sequel.migration do
  up do
    create_table :sellers do
      primary_key :id
      String      :full_name, null: false
      String      :email, null: false
      String      :phone, null: false
      DateTime    :created_at, null: false
      DateTime    :updated_at, null: false

      index :email, unique: true
    end
  end

  down do
    drop_table :sellers
  end
end
