class CreateChampionMatches < ActiveRecord::Migration
  def change
    create_table :champion_matches do |t|
      t.integer :summoner_id, index: true
      t.integer :champion_id, index: true
      t.integer :match_id, index: true
      t.string :season, index: true
      t.string :version, index: true
      t.integer :duration
      t.string :tier, index: true
      t.string :division
      t.string :lane, index: true
      t.string :role, index: true
      t.boolean :winner, index: true
      t.integer :kills
      t.integer :deaths
      t.integer :assists
      t.integer :tower_kills
      t.integer :inhibitor_kills
      t.integer :wards_placed
      t.integer :wards_killed
      t.boolean :first_blood_kill
      t.boolean :first_blood_assist

      t.decimal :xp_per_min_0_10
      t.decimal :xp_per_min_10_20
      t.decimal :xp_per_min_20_30
      t.decimal :xp_per_min_30_end

      t.decimal :xp_diff_0_10
      t.decimal :xp_diff_10_20
      t.decimal :xp_diff_20_30
      t.decimal :xp_diff_30_end

      t.decimal :cs_per_min_0_10
      t.decimal :cs_per_min_10_20
      t.decimal :cs_per_min_20_30
      t.decimal :cs_per_min_30_end

      t.decimal :cs_diff_0_10
      t.decimal :cs_diff_10_20
      t.decimal :cs_diff_20_30
      t.decimal :cs_diff_30_end

      t.decimal :gold_per_min_0_10
      t.decimal :gold_per_min_10_20
      t.decimal :gold_per_min_20_30
      t.decimal :gold_per_min_30_end

      t.decimal :damage_taken_diff_0_10
      t.decimal :damage_taken_diff_10_20
      t.decimal :damage_taken_diff_20_30
      t.decimal :damage_taken_diff_30_end

      t.integer :total_damage_dealt_champs
      t.integer :total_damage_taken

      t.integer :total_cs
      t.integer :monsters_enemy_jungle
      t.integer :monsters_team_jungle

      t.integer :team_dragon_kills
      t.integer :team_baron_kills
      t.integer :team_tower_kills
      t.integer :team_inhibitor_kills

      t.timestamps null: false
    end
  end
end
