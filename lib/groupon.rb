require 'httparty'
require 'hashie'
require 'groupon/client'


Hash.send :include, Hashie::HashExtensions

module Groupon

  # Returns a list of divisions - cities where Groupon is live.
  # @see http://sites.google.com/site/grouponapi/divisions-api  Groupon API docs
  # @return [Array<Hashie::Mash>] an array of divisions
  def self.divisions
    Groupon::Client.new.divisions
  end

  # Returns a list of deals.
  #   The API returns an ordered list of deals currently running for a given Division.
  #   Priority is based on position within the response (top deals are higher in priority).
  #
  # @see http://sites.google.com/site/grouponapi/divisions-api  Groupon API docs
  #
  # @option options [String] :lat (Latitudinal coordinates based on IP of API request) Latitude of geolocation to find deals
  # @option options [String] :lng (Longtitudinal coordinates based on IP of API request) Longitude of geolocation to find deals
  # @return [Array<Hashie::Mash>] an array of deals
  def self.deals(options={})
    Groupon::Client.new.deals(options)
  end

  # Return a deal by id
  #   Shows detailed information about a specified deal
  # @see https://sites.google.com/site/grouponapiv2/api-resources/deals#show-request
  def self.deal(id)
    Groupon::Client.new.deal(id)
  end

  class << self

    # Get/sets the required Groupon API token
    # @see http://sites.google.com/site/grouponapi/home  Groupon API docs
    #
    # @param [String]
    # @return [String]
    attr_accessor :api_key
  end

  # Contains information for errors returned by the API
  class GrouponError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end
end

