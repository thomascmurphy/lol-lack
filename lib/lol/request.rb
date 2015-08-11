module Lol
  class Request

    include HTTParty
    base_uri 'https://na.api.pvp.net/api/lol'

    def initialize(region)
      @api_version = 1.2
      @region = region
      @options = { query: {api_key: Rails.application.secrets.lol_api_key} }
    end

    def call(url, extra_query={}, static_data=false)
      @base_api = "/#{@region}/v#{@api_version}/"
      if static_data
        @base_api.prepend("/static-data")
      end
      @options[:query] = @options[:query].merge(extra_query)
      self.class.get(@base_api + url, @options)
    end

    def latest_version
      call('versions', {}, true)[0]
    end

    def champions
      call('champion', {}, true)['data']
    end

    def champion(id, query={})
      call("champion/#{id}", query, true)['data']
    end

  end
end
