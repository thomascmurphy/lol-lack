class ChampionMatch < ActiveRecord::Base

  def convert_common_fields(api_response)
    self.match_id = api_response["matchId"]
    self.region = api_response["region"]
    self.season = api_response["season"]
    self.version = api_response["matchVersion"]
    self.duration = api_response["matchDuration"]
    self.save()
  end

  def convert_team_fields(api_response)
    self.team_dragon_kills = api_response["dragonKills"]
    self.team_baron_kills = api_response["baronKills"]
    self.team_tower_kills = api_response["towerKills"]
    self.team_inhibitor_kills = api_response["inhibitorKills"]
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
end
