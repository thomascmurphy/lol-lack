class AddTimestamps < ActiveRecord::Migration
  def change
    add_column :matches, :timestamp, :timestamp
    add_column :champion_matches, :timestamp, :timestamp
  end
end
