namespace :static_data do
  desc "Seed the champion data"
  task champions: :environment do
    require 'lol/request'

    lol_request = Lol::Request.new('na')
    champions = lol_request.champions()
    champions.each do |champion_name, champion_data|
      champ = Champion.find_or_create_by(champion_id: champion_data['id'], name: champion_name)
      champ.save()
    end
  end

  task champion_images: :environment do
    require 'lol/request'

    lol_request = Lol::Request.new('na')
    version = lol_request.latest_version()
    Champion.all.each do |champion|
      champion.image = "http://ddragon.leagueoflegends.com/cdn/#{version}/img/champion/#{champion.name}.png"
      champion.save()
    end
  end

  task seed_game_data: :environment do
    #60263441 = tomutron (silver)
    #19522880 = All Star Akali (silver)
    #53884466 = Vulgate (gold)
    #40308699 = G0liath online (platinum)
    #39567812 = Dragon SS (diamond)
    #25850956 = Nightblue3 (master)
    #65409090 = GodPiglet (challenger)
    summoner_ids = [60263441, 19522880, 53884466, 40308699, 39567812, 25850956, 65409090]
    query = {rankedQueues: 'TEAM_BUILDER_DRAFT_RANKED_5x5'}
    summoner_ids.each do |summoner_id|
      Match.grab_summoner_match_ids(summoner_id, 'na', query)
    end
  end

  task convert_game_data: :environment do
    Delayed::Job.where("run_at < '#{DateTime.now().utc - 5.minutes}'")
    if Delayed::Job.where("handler LIKE '%MatchDataJob%'").count() < 100
      limit = Rails.env == 'production' ? 50 : 10
      if Rails.env == 'production'
        matches = Match.where(processed: false).limit(limit).order("timestamp DESC NULLS LAST, RANDOM()")
      else
        matches = Match.where(processed: false).limit(limit).order("timestamp DESC, RANDOM()")
      end
      matches.each do |match|
        Delayed::Job.enqueue(MatchDataJob.new(match.id), run_at:MatchDataJob.queue_time())
      end
    end
  end

  task clean_old_game_data: :environment do
    Match.where("timestamp < ?", Match.date_cutoff()).delete_all()
    ChampionMatch.where("timestamp < ?", Match.date_cutoff()).delete_all()
  end

end
