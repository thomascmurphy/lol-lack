class CreateSummoners < ActiveRecord::Migration
  def change
    create_table :summoners do |t|
      t.integer :summoner_id
      t.string :summoner_name
      t.datetime :last_checked
      t.string :region
      t.string :tier
      t.string :division

      t.timestamps null: false
    end
    add_index :summoners, :summoner_id
    add_index :summoners, :summoner_name
    add_index :summoners, :tier
  end
end
