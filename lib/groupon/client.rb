module Groupon
  class Client
    attr_accessor :api_key
    include HTTParty
    base_uri "http://api.groupon.com/v2"
    format :json

    # Initialize the Groupon client
    #
    # @option options [String] :api_key (Groupon.api_key) Your Groupon API token

    def initialize(options={})
      @api_key = options[:api_key] || Groupon.api_key
    end
    # Returns a list of divisions - cities where Groupon is live.
    # @see http://sites.google.com/site/grouponapi/divisions-api  Groupon API docs
    #
    # @return [Array<Hashie::Mash>] an array of divisions
    def divisions
      self.class.get("/divisions.json",:query => { :client_id => @api_key }).divisions
    end

    # Returns a list of deals.
    #
    #   The API returns an ordered list of deals currently running for a given Division.
    #
    #   Priority is based on position within the response (top deals are higher in priority).
    #
    #
    #
    # @see http://sites.google.com/site/grouponapi/divisions-api Groupon API docs
    #
    #
    #
    # @option options [String] :lat (Latitudinal coordinates based on IP of API request) Latitude of geolocation to find deals
    #
    # @option options [String] :lng (Longtitudinal coordinates based on IP of API request) Longitude of geolocation to find deals
    #
    # @return [Array<Hashie::Mash>] an array of deals
    def deals(query={})
      division = query.delete(:division)
      query.merge! :client_id => @api_key
      query.merge! :channel_id => 'goods'
      path = division ? "/#{division}" : ""
      path += "/deals.json"
      puts query
      self.class.get(path, :query => query).deals
    end

    # Return a deal by id
    #   Shows detailed information about a specified deal
    # @see https://sites.google.com/site/grouponapiv2/api-resources/deals#show-request
    def deal(id)
      self.class.get("/deals/#{id}.json", :query => {:channel_id => 'goods', :client_id => @api_key}).deal
    end

    def self.get(*args); handle_response super end
    def self.post(*args); handle_response super end

    def self.handle_response(response)
      case response.code
      when 500...600; raise GrouponError.new(Hashie::Mash.new(response).status)
      else; response
      end

      Hashie::Mash.new(response)

    end
  end
end
