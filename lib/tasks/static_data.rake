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

end
