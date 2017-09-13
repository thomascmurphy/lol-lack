module Lol
  class NotFound < StandardError; end
  class TooManyRequests < StandardError; end
  class InvalidAPIResponse < StandardError; end

  class Request

    include HTTParty
    base_uri 'https://na.api.riotgames.com/lol'

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
        raise NotFound.new("404 Not Found #{url} #{extra_query}") if response.not_found?
        raise TooManyRequests.new("429 Rate limit exceeded, retry after: #{response.headers['retry-after']}, type: #{response.headers['x-rate-limit-type']}") if response.code == 429
        raise InvalidAPIResponse.new(response)
      end
      response
    end

    def latest_version
      call('versions', 3, {}, true)[0]
    end

    def champions
      call('champions', 3, {}, true)['data']
    end

    def champion(id, query={})
      call("champions/#{id}", 3, query, true)
    end

    def summoner_by_name(summoner_name)
      call("summoner/by-name/#{summoner_name}", 3)
    end

    def match_list(account_id, query={})
      call("matchlists/by-account/#{account_id}", 3, query)
    end

    def match_history_detailed(user_id, query={})
      call("matchhistory/#{user_id}", 3, query)
    end

    def match_detail(match_id)
      call("matches/#{match_id}", 3)
    end

    def league_by_summoner(summoner_id)
      call("leagues/by-summoner/#{summoner_id}", 3)
    end

  end
end
