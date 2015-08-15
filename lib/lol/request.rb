module Lol
  class Request

    include HTTParty
    base_uri 'https://na.api.pvp.net/api/lol'

    def initialize(region)
      @region = region
      @options = { query: {api_key: Rails.application.secrets.lol_api_key} }
    end

    def call(url, api_version, extra_query={}, static_data=false)
      @base_api = "/#{@region}/v#{api_version}/"
      if static_data
        @base_api.prepend("/static-data")
      end
      @options[:query] = @options[:query].merge(extra_query)
      self.class.get(@base_api + url, @options)
    end

    def latest_version
      call('versions', 1.2, {}, true)[0]
    end

    def champions
      call('champion', 1.2, {}, true)['data']
    end

    def champion(id, query={})
      call("champion/#{id}", 1.2, query, true)['data']
    end

    def summoner_by_name(summoner_name)
      call("summoner/by-name/#{summoner_name}", 1.4)
    end

    def match_list(user_id, query={})
      call("matchlist/by-summoner/#{user_id}", 2.2, query)
    end

    def match_history_detailed(user_id, query={})
      call("matchhistory/#{user_id}", 2.2, query)
    end

    def league_by_summoner(summoner_id)
      call("league/by-summoner/#{summoner_id}", 2.5)
    end

  end
end
