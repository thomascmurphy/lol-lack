class Summoner < ActiveRecord::Base
  before_validation :clean_name
  validates :summoner_name, :presence => true, :uniqueness => true

  private

  def clean_name
    self.summoner_name = ERB::Util.url_encode(self.summoner_name.downcase.gsub(/\s+/, "")) if self.summoner_name.present?
  end
end
