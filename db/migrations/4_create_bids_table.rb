Sequel.migration do
  up do
    create_table :bids do
      primary_key :id
      Integer     :listing_id, null: false
      Integer     :agent_id, null: false
      Integer     :accepted, null: false, default: 0
      Integer     :close_price, null: false
      Integer     :duration, null: false
      Float       :commission, null: false
      DateTime    :created_at, null: false
      DateTime    :updated_at, null: false
    end
  end

  down do
    drop_table :bids
  end
end
