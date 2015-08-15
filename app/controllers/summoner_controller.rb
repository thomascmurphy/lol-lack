class SummonerController < ApplicationController
  def index
  end

  def show
    require 'lol/request'
    if params[:summoner_name].present?
      @summoner_name = ERB::Util.url_encode(params[:summoner_name].downcase.gsub(/\s+/, ""))
      @summoner = Summoner.find_or_initialize_by(summoner_name: @summoner_name)
      if @summoner.new_record?
        lol_request = Lol::Request.new('na')
        summoner_data = lol_request.summoner_by_name(@summoner_name)
        @summoner.summoner_id = summoner_data[summoner_data.keys[0]]["id"]
        @summoner.save()
      end

      query = {championIds: params[:champion_id], rankedQueues: 'RANKED_SOLO_5x5'}
      user_games = lol_request.match_list(@summoner.summoner_id, query)
      @user_game_ids = user_games["matches"].map{|match| match["matchId"]}
    else
      redirect_to index
    end
  end


end
