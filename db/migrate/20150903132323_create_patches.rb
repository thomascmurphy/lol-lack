class CreatePatches < ActiveRecord::Migration
  def change
    create_table :patches do |t|
      t.string :name
      t.string :version
      t.timestamp :start

      t.timestamps null: false
    end
  end
end
