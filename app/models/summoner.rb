class Summoner < ActiveRecord::Base
  before_validation :clean_name
  validates :summoner_name, :presence => true, :uniqueness => true

  def next_tier
    case self.tier.downcase
    when 'bronze'
      "SILVER"
    when 'silver'
      "GOLD"
    when 'gold'
      "PLATINUM"
    when 'platinum'
      "DIAMOND"
    when 'diamond'
      "MASTER"
    when 'master'
      "CHALLENGER"
    when 'challenger'
      "CHALLENGER"
    end
  end

  def get_champion_matches(query={})
    matches = Match.grab_summoner_match_ids(self.summoner_id, self.region, query)
    champion_match_ids = []
    matches.each do |match|
      champion_match_ids += match.process_stats(false)
    end
    ChampionMatch.where(id: champion_match_ids, summoner_id: self.summoner_id)
  end

  private

  def clean_name
    self.summoner_name = ERB::Util.url_encode(self.summoner_name.downcase.gsub(/\s+/, "")) if self.summoner_name.present?
  end

end
