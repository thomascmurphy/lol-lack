class Match < ActiveRecord::Base

  def process_stats(propogate=true)
    champion_match_ids = []
    if self.processed.blank?
      require 'lol/request'
      lol_request = Lol::Request.new(self.region)
      api_response = lol_request.match_detail(self.match_id)
      if api_response.present? && api_response.has_key?("participantIdentities")
        summoners = []
        api_response["participantIdentities"].each do |participant|
          summoner_id = participant["player"]["summonerId"]
          participant_id =  participant["participantId"]
          participant_data = api_response["participants"][api_response["participants"].find_index {|item| item["participantId"] == participant_id}]
          team_id = participant_data["teamId"]
          team_data = api_response["teams"][api_response["teams"].find_index {|item| item["teamId"] == team_id}]
          existing_match = ChampionMatch.find_by(match_id: api_response["matchId"], summoner_id: summoner_id)
          if existing_match.blank?
            champion_match = ChampionMatch.new()
            champion_match.convert_common_fields(api_response)
            champion_match.convert_team_fields(team_data)
            champion_match.convert_team_calculated_fields(api_response, team_id)
            champion_match.convert_summoner_fields(participant_data, summoner_id)
            champion_match_ids << champion_match.id
          else
            champion_match_ids << existing_match.id
          end
          if propogate && ChampionMatch.where(champion_id: participant_data["championId"], tier: participant_data["highestAchievedSeasonTier"]).count < 50
                       && Match.where(processed: false).count() < 1000000
            matches = self.class.grab_summoner_match_ids(summoner_id, self.region)
          end
        end
        self.processed = true
        self.save()
      end
    else
      champion_match_ids = ChampionMatch.where(match_id: self.match_id).pluck(:id)
    end
    champion_match_ids
  end

  def self.grab_summoner_match_ids(summoner_id, region, query={})
    require 'lol/request'
    lol_request = Lol::Request.new(region)
    user_games = lol_request.match_list(summoner_id, query)
    match_ids = []
    if user_games.has_key?("matches") && user_games["matches"].present?
      user_games["matches"].each do |user_game|
        match = Match.find_or_create_by(match_id: user_game["matchId"], region: region)
        match_ids << match.id
      end
      Match.where(id: match_ids)
    else
      match_ids
    end
  end
end
