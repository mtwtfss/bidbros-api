Sequel.migration do
  up do
    create_table :listings do
      primary_key :id
      Integer     :seller_id, null: false
      String      :listing_id, null: false
      DateTime    :created_at, null: false
      DateTime    :updated_at, null: false

      index :listing_id, unique: true
    end
  end

  down do
    drop_table :listings
  end
end
