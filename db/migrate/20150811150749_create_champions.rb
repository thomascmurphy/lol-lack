class CreateChampions < ActiveRecord::Migration
  def change
    create_table :champions do |t|
      t.string :name
      t.integer :champion_id, index: true
      t.string :image

      t.timestamps null: false
    end
  end
end
