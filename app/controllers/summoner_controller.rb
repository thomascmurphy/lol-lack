class SummonerController < ApplicationController
  def index
  end

  def search
    if params[:summoner_name].present?
      redirect_to summoner_path(summoner_name: params[:summoner_name],
                                champion_id: params[:champion_id],
                                role: params[:role],
                                tier: params[:tier],
                                region: params[:region])
    else
      flash[:alert] = "Please enter a valid summoner name"
      redirect_to action: "index"
    end
  end

  def show
    @wide_content = false
    require 'lol/request'
    if params[:summoner_name].present? && params[:champion_id].present?
      region = params[:region] || 'na'
      @summoner_name = ERB::Util.url_encode(params[:summoner_name].downcase.gsub(/\s+/, ""))
      @summoner = Summoner.find_or_initialize_by(summoner_name: @summoner_name, region: region)
      @champion = Champion.find_by(champion_id: params[:champion_id])
      @role = params[:role]
      user_game_ids = []
      lol_request = Lol::Request.new(region)
      if @summoner.new_record?
        summoner_data = lol_request.summoner_by_name(@summoner_name)
        @summoner.summoner_id = summoner_data[summoner_data.keys[0]]["id"]
        full_league_data = lol_request.league_by_summoner(@summoner.summoner_id)
        league_data = full_league_data[full_league_data.keys[0]]
        solo_league = league_data[league_data.find_index {|ranking| ranking["queue"] == "RANKED_SOLO_5x5"}]
        @summoner.tier = solo_league["tier"]
        @summoner.save()
      end

      champion_id = params[:champion_id]
      lane_role = ChampionMatch.convertRole(params[:role])
      query = {championIds: champion_id, rankedQueues: 'RANKED_SOLO_5x5'}
      user_games = @summoner.get_champion_matches(query)
      @user_stats = ChampionMatch.average_values(user_games)

      only_wins = params[:only_wins] == "false" ? false : true
      @tier = params[:tier] || @summoner.next_tier()
      comparison_games = ChampionMatch.where(champion_id: champion_id,
                                             lane: lane_role[:lane],
                                             role: lane_role[:role],
                                             tier: @tier,
                                             winner: only_wins)

      @average_stats = ChampionMatch.average_values(comparison_games)
    else
      flash[:alert] = "Please enter a champion and role"
      redirect_to action: "index"
    end
  end


end
