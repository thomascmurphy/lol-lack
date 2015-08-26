module Lol
  class NotFound < StandardError; end
  class TooManyRequests < StandardError; end
  class InvalidAPIResponse < StandardError; end

  class Request

    include HTTParty
    base_uri 'https://na.api.pvp.net/api/lol'

    def initialize(region="na")
      @region = region
      @options = { query: {api_key: Rails.application.secrets.lol_api_key} }
    end

    def call(url, api_version, extra_query={}, static_data=false)
      @base_api = "/#{@region}/v#{api_version}/"
      if static_data
        @base_api.prepend("/static-data")
      end
      @options[:query] = @options[:query].merge(extra_query)
      response = self.class.get(@base_api + url, @options)
      if response.respond_to?(:code) && !(200...300).include?(response.code)
        raise NotFound.new("404 Not Found") if response.not_found?
        raise TooManyRequests.new('429 Rate limit exceeded') if response.code == 429
        raise InvalidAPIResponse.new(@options)
      end
      response
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

    def match_detail(match_id)
      call("match/#{match_id}", 2.2)
    end

    def league_by_summoner(summoner_id)
      call("league/by-summoner/#{summoner_id}/entry", 2.5)
    end

  end
end
