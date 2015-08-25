class BigIntIds < ActiveRecord::Migration
  def change
    change_column :champion_matches, :match_id, :bigint
    change_column :champion_matches, :summoner_id, :bigint
    change_column :matches, :match_id, :bigint
    change_column :summoners, :summoner_id, :bigint
  end
end
