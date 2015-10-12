class ChampionMatch < ActiveRecord::Base

  def convert_common_fields(api_response)
    self.match_id = api_response["matchId"]
    self.region = api_response["region"]
    self.season = api_response["season"]
    self.version = api_response["matchVersion"]
    self.duration = api_response["matchDuration"]
    self.timestamp = Time.at((api_response["matchCreation"]/1000).round(0)).utc
    self.save()
  end

  def convert_team_fields(api_response)
    self.team_dragon_kills = api_response["dragonKills"]
    self.team_baron_kills = api_response["baronKills"]
    self.team_tower_kills = api_response["towerKills"]
    self.team_inhibitor_kills = api_response["inhibitorKills"]
    self.save()
  end

  def convert_team_calculated_fields(api_response, team_id)
    team_kills = 0
    team_deaths = 0
    api_response["participants"].each do |participant_data|
      if participant_data["teamId"] == team_id
        team_kills += participant_data["stats"]["kills"]
        team_deaths += participant_data["stats"]["deaths"]
      end
    end
    self.team_kills = team_kills
    self.team_deaths = team_deaths
    self.save()
  end

  def convert_summoner_fields(api_response, summoner_id)
    self.summoner_id = summoner_id
    self.tier = api_response["highestAchievedSeasonTier"]
    self.champion_id = api_response["championId"]
    self.lane = api_response["timeline"]["lane"]
    self.role = api_response["timeline"]["role"]
    self.winner = api_response["stats"]["winner"]
    self.kills = api_response["stats"]["kills"]
    self.deaths = api_response["stats"]["deaths"]
    self.assists = api_response["stats"]["assists"]
    self.tower_kills = api_response["stats"]["towerKills"]
    self.inhibitor_kills = api_response["stats"]["inhibitorKills"]
    self.wards_placed = api_response["stats"]["wardsPlaced"]
    self.wards_killed = api_response["stats"]["wardsKilled"]
    self.first_blood_kill = api_response["stats"]["firstBloodKill"]
    self.first_blood_assist = api_response["stats"]["firstBloodAssist"]
    self.total_damage_dealt_champs = api_response["stats"]["totalDamageDealtToChampions"]
    self.total_damage_taken = api_response["stats"]["totalDamageTaken"]
    self.total_cs = api_response["stats"]["minionsKilled"]
    self.monsters_enemy_jungle = api_response["stats"]["neutralMinionsKilledEnemyJungle"]
    self.monsters_team_jungle = api_response["stats"]["neutralMinionsKilledTeamJungle"]

    if api_response["timeline"].has_key?("xpPerMinDeltas")
      self.xp_per_min_0_10 = api_response["timeline"]["xpPerMinDeltas"]["zeroToTen"]
      self.xp_per_min_10_20 = api_response["timeline"]["xpPerMinDeltas"]["tenToTwenty"]
      self.xp_per_min_20_30 = api_response["timeline"]["xpPerMinDeltas"]["twentyToThirty"]
      self.xp_per_min_30_end = api_response["timeline"]["xpPerMinDeltas"]["thirtyToEnd"]
    end

    if api_response["timeline"].has_key?("xpDiffPerMinDeltas")
      self.xp_diff_0_10 = api_response["timeline"]["xpDiffPerMinDeltas"]["zeroToTen"]
      self.xp_diff_10_20 = api_response["timeline"]["xpDiffPerMinDeltas"]["tenToTwenty"]
      self.xp_diff_20_30 = api_response["timeline"]["xpDiffPerMinDeltas"]["twentyToThirty"]
      self.xp_diff_30_end = api_response["timeline"]["xpDiffPerMinDeltas"]["thirtyToEnd"]
    end

    if api_response["timeline"].has_key?("creepsPerMinDeltas")
      self.cs_per_min_0_10 = api_response["timeline"]["creepsPerMinDeltas"]["zeroToTen"]
      self.cs_per_min_10_20 = api_response["timeline"]["creepsPerMinDeltas"]["tenToTwenty"]
      self.cs_per_min_20_30 = api_response["timeline"]["creepsPerMinDeltas"]["twentyToThirty"]
      self.cs_per_min_30_end = api_response["timeline"]["creepsPerMinDeltas"]["thirtyToEnd"]
    end

    if api_response["timeline"].has_key?("csDiffPerMinDeltas")
      self.cs_diff_0_10 = api_response["timeline"]["csDiffPerMinDeltas"]["zeroToTen"]
      self.cs_diff_10_20 = api_response["timeline"]["csDiffPerMinDeltas"]["tenToTwenty"]
      self.cs_diff_20_30 = api_response["timeline"]["csDiffPerMinDeltas"]["twentyToThirty"]
      self.cs_diff_30_end = api_response["timeline"]["csDiffPerMinDeltas"]["thirtyToEnd"]
    end

    if api_response["timeline"].has_key?("goldPerMinDeltas")
      self.gold_per_min_0_10 = api_response["timeline"]["goldPerMinDeltas"]["zeroToTen"]
      self.gold_per_min_10_20 = api_response["timeline"]["goldPerMinDeltas"]["tenToTwenty"]
      self.gold_per_min_20_30 = api_response["timeline"]["goldPerMinDeltas"]["twentyToThirty"]
      self.gold_per_min_30_end = api_response["timeline"]["goldPerMinDeltas"]["thirtyToEnd"]
    end

    if api_response["timeline"].has_key?("damageTakenDiffPerMinDeltas")
      self.damage_taken_diff_0_10 = api_response["timeline"]["damageTakenDiffPerMinDeltas"]["zeroToTen"]
      self.damage_taken_diff_10_20 = api_response["timeline"]["damageTakenDiffPerMinDeltas"]["tenToTwenty"]
      self.damage_taken_diff_20_30 = api_response["timeline"]["damageTakenDiffPerMinDeltas"]["twentyToThirty"]
      self.damage_taken_diff_30_end = api_response["timeline"]["damageTakenDiffPerMinDeltas"]["thirtyToEnd"]
    end

    self.save()
  end

  def self.average_values(champion_match_ids)
    if champion_match_ids.count > 0
      average_query = %Q(
        SELECT AVG(cm.duration) AS duration,
          AVG(cm.kills) AS kills,
          AVG(cm.deaths) AS deaths,
          AVG(cm.assists) AS assists,
          AVG(cm.tower_kills) AS tower_kills,
          AVG(cm.inhibitor_kills) AS inhibitor_kills,
          AVG(cm.wards_placed) AS wards_placed,
          AVG(cm.wards_killed) AS wards_killed,
          AVG(cm.xp_per_min_0_10) AS xp_per_min_0_10,
          AVG(cm.xp_per_min_10_20) AS xp_per_min_10_20,
          AVG(cm.xp_per_min_20_30) AS xp_per_min_20_30,
          AVG(cm.xp_per_min_30_end) AS xp_per_min_30_end,
          AVG(cm.xp_diff_0_10) AS xp_diff_0_10,
          AVG(cm.xp_diff_10_20) AS xp_diff_10_20,
          AVG(cm.xp_diff_20_30) AS xp_diff_20_30,
          AVG(cm.xp_diff_30_end) AS xp_diff_30_end,
          AVG(cm.cs_per_min_0_10) AS cs_per_min_0_10,
          AVG(cm.cs_per_min_10_20) AS cs_per_min_10_20,
          AVG(cm.cs_per_min_20_30) AS cs_per_min_20_30,
          AVG(cm.cs_per_min_30_end) AS cs_per_min_30_end,
          AVG(cm.cs_diff_0_10) AS cs_diff_0_10,
          AVG(cm.cs_diff_10_20) AS cs_diff_10_20,
          AVG(cm.cs_diff_20_30) AS cs_diff_20_30,
          AVG(cm.cs_diff_30_end) AS cs_diff_30_end,
          AVG(cm.gold_per_min_0_10) AS gold_per_min_0_10,
          AVG(cm.gold_per_min_10_20) AS gold_per_min_10_20,
          AVG(cm.gold_per_min_20_30) AS gold_per_min_20_30,
          AVG(cm.gold_per_min_30_end) AS gold_per_min_30_end,
          AVG(cm.damage_taken_diff_0_10) AS damage_taken_diff_0_10,
          AVG(cm.damage_taken_diff_10_20) AS damage_taken_diff_10_20,
          AVG(cm.damage_taken_diff_20_30) AS damage_taken_diff_20_30,
          AVG(cm.damage_taken_diff_30_end) AS damage_taken_diff_30_end,
          AVG(cm.total_damage_dealt_champs) AS total_damage_dealt_champs,
          AVG(cm.total_damage_taken) AS total_damage_taken,
          AVG(cm.total_cs) AS total_cs,
          AVG(cm.monsters_enemy_jungle) AS monsters_enemy_jungle,
          AVG(cm.monsters_team_jungle) AS monsters_team_jungle,
          AVG(cm.team_dragon_kills) AS team_dragon_kills,
          AVG(cm.team_baron_kills) AS team_baron_kills,
          AVG(cm.team_tower_kills) AS team_tower_kills,
          AVG(cm.team_inhibitor_kills) AS team_inhibitor_kills,
          AVG(cm.team_kills) AS team_kills,
          AVG(cm.team_deaths) AS team_deaths

        FROM champion_matches cm
        WHERE cm.id IN (#{champion_match_ids.join(',')})
      )

      first_blood_query = %Q(
        SELECT COUNT(cm.id) AS first_blood_participation
        FROM champion_matches cm
        WHERE cm.id IN (#{champion_match_ids.join(',')}) AND (cm.first_blood_kill=1 OR cm.first_blood_assist=1)
      )

      winner_query = %Q(
        SELECT COUNT(cm.id) AS winner_count
        FROM champion_matches cm
        WHERE cm.id IN (#{champion_match_ids.join(',')}) AND (cm.winner=1)
      )

      averages = ActiveRecord::Base.connection.execute(average_query).entries.first
      first_blood_data = ActiveRecord::Base.connection.execute(first_blood_query).entries.first
      winner_data = ActiveRecord::Base.connection.execute(winner_query).entries.first

      match_count = champion_match_ids.count
      kda = averages["deaths"] > 0 ? (averages["kills"] + averages["assists"]) / averages["deaths"] : averages["kills"] + averages["assists"]
      structures_destroyed = averages["inhibitor_kills"] + averages["tower_kills"]
      team_structures_destroyed = averages["team_inhibitor_kills"] + averages["team_tower_kills"]
      structure_participation = team_structures_destroyed > 0 ? structures_destroyed / team_structures_destroyed : 0
      first_blood_participation = first_blood_data["first_blood_participation"].to_f / match_count.to_f
      kill_participation = averages["team_kills"] > 0 ? averages["kills"] / averages["team_kills"] : 1
      death_participation = averages["team_deaths"] > 0 ? averages["deaths"] / averages["team_deaths"] : 0

      xp_per_min = {zero_ten: (averages["xp_per_min_0_10"] || 0).round(2).to_f,
                    ten_twenty: (averages["xp_per_min_10_20"] || 0).round(2).to_f,
                    twenty_thirty: (averages["xp_per_min_20_30"] || 0).round(2).to_f,
                    thirty_end: (averages["xp_per_min_30_end"] || 0).round(2).to_f}
      xp_diff = {zero_ten: (averages["xp_diff_0_10"] || 0).round(2).to_f,
                 ten_twenty: (averages["xp_diff_10_20"] || 0).round(2).to_f,
                 twenty_thirty: (averages["xp_diff_20_30"] || 0).round(2).to_f,
                 thirty_end: (averages["xp_diff_30_end"] || 0).round(2).to_f}
      cs_per_min = {zero_ten: (averages["cs_per_min_0_10"] || 0).round(2).to_f,
                    ten_twenty: (averages["cs_per_min_10_20"] || 0).round(2).to_f,
                    twenty_thirty: (averages["cs_per_min_20_30"] || 0).round(2).to_f,
                    thirty_end: (averages["cs_per_min_30_end"] || 0).round(2).to_f}
      cs_diff = {zero_ten: (averages["cs_diff_0_10"] || 0).round(2).to_f,
                 ten_twenty: (averages["cs_diff_10_20"] || 0).round(2).to_f,
                 twenty_thirty: (averages["cs_diff_20_30"] || 0).round(2).to_f,
                 thirty_end: (averages["cs_diff_30_end"] || 0).round(2).to_f}
      gold_per_min = {zero_ten: (averages["gold_per_min_0_10"] || 0).round(2).to_f,
                      ten_twenty: (averages["gold_per_min_10_20"] || 0).round(2).to_f,
                      twenty_thirty: (averages["gold_per_min_20_30"] || 0).round(2).to_f,
                      thirty_end: (averages["gold_per_min_30_end"] || 0).round(2).to_f}
      damage_taken_diff = {zero_ten: (averages["damage_taken_diff_0_10"] || 0).round(2).to_f,
                           ten_twenty: (averages["damage_taken_diff_10_20"] || 0).round(2).to_f,
                           twenty_thirty: (averages["damage_taken_diff_20_30"] || 0).round(2).to_f,
                           thirty_end: (averages["damage_taken_diff_30_end"] || 0).round(2).to_f}

      {count: match_count,
       win_rate: (winner_data["winner_count"].to_f / match_count.to_f).round(3).to_f,
       kda: kda.round(2).to_f,
       duration: averages["duration"].round(0).to_f,
       structure_participation: structure_participation.round(3).to_f,
       wards_placed: averages["wards_placed"].round(2).to_f,
       wards_killed: averages["wards_killed"].round(2).to_f,
       first_blood_participation: first_blood_participation.round(3).to_f,
       kill_participation: kill_participation.round(3).to_f,
       death_participation: death_participation.round(3).to_f,
       total_damage_dealt_champs: averages["total_damage_dealt_champs"].round(2).to_f,
       total_damage_taken: averages["total_damage_taken"].round(2).to_f,
       monsters_team_jungle: averages["monsters_team_jungle"].round(2).to_f,
       monsters_enemy_jungle: averages["monsters_enemy_jungle"].round(2).to_f,
       team_dragon_kills: averages["team_dragon_kills"].round(2).to_f,
       team_baron_kills: averages["team_baron_kills"].round(2).to_f,
       total_cs: averages["total_cs"].round(2).to_f,
       xp_per_min: xp_per_min,
       xp_diff: xp_diff,
       cs_per_min: cs_per_min,
       cs_diff: cs_diff,
       gold_per_min: gold_per_min,
       damage_taken_diff: damage_taken_diff}
    else
      nil
    end
  end

  def self.convertRole(role)
    lane_role = {lane: "", role: ""}
    if (role.present?)
      case role.downcase
      when 'top'
        lane_role[:lane] = 'TOP'
        lane_role[:role] = 'SOLO'
      when 'jungle'
        lane_role[:lane] = 'JUNGLE'
        lane_role[:role] = 'NONE'
      when 'mid'
        lane_role[:lane] = 'MIDDLE'
        lane_role[:role] = 'SOLO'
      when 'adc'
        lane_role[:lane] = 'BOTTOM'
        lane_role[:role] = 'DUO_CARRY'
      when 'support'
        lane_role[:lane] = 'BOTTOM'
        lane_role[:role] = 'DUO_SUPPORT'
      end
    end
    return lane_role
  end
end
