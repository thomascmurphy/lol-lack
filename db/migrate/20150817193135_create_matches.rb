class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :match_id, index: true
      t.string :region, index: true
      t.boolean :processed, default: false, index: true

      t.timestamps null: false
    end
  end
end
