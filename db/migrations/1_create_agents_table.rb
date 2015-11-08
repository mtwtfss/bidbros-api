Sequel.migration do
  up do
    create_table :agents do
      primary_key :id
      String      :agent_id, null: false
      String      :yelp_url
      DateTime    :created_at, null: false
      DateTime    :updated_at, null: false

      index :agent_id, unique: true
    end
  end

  down do
    drop_table :agents
  end
end
