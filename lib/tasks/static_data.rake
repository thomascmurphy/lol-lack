namespace :static_data do
  desc "Seed the champion data"
  task champions: :environment do
    require 'lol/request'

    lol_request = Lol::Request.new('na')
    champions = lol_request.champions()
    champions.each do |champion_name, champion_data|
      champ = Champion.create(champion_id: champion_data['id'], name: champion_name)
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

  task initial_game_data: :environment do
    #60263441 = tomutron (silver)
    #19522880 = All Star Akali (silver)
    #53884466 = Vulgate (gold)
    #40308699 = G0liath online (platinum)
    #39567812 = Dragon SS (diamond)
    #25850956 = Nightblue3 (master)
    #65409090 = GodPiglet (challenger)
    summoner_ids = [60263441, 19522880, 53884466, 40308699, 39567812, 25850956, 65409090]
    summoner_ids.each do |summoner_id|
      Match.grab_summoner_match_ids(summoner_id, 'na')
    end
  end

  task convert_game_data: :environment do
    if Delayed::Job.where("handler LIKE '%MatchDataJob%'").count() < 100
      limit = Rails.env == 'production' ? 100 : 10
      matches = Match.where(processed: false).limit(limit)
      matches.each do |match|
        Delayed::Job.enqueue(MatchDataJob.new(match.id), run_at:MatchDataJob.queue_time())
      end
    end
  end

end
