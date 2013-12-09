require 'yaml'
require 'logger'
require 'rest_client'

class Halo
	attr_accessor :client_id
	attr_accessor :client_secret

  attr_accessor :token
  attr_accessor :token_expires
  attr_accessor :token_scope

  HALO_URI = "https://api.cloudpassage.com/v1/"

	def initialize
    @log = Logger.new(STDOUT)
    @log.level = Logger::DEBUG

		settings = YAML.load_file("config/newrelic_plugin.yml")
		@client_id = settings['agents']['cloud_passage']['client_id']
		@client_secret = settings['agents']['cloud_passage']['client_secret']
	end

  def events(since=Time.now, event_types=[])
    params = {:since => since.utc().iso8601()}

    if event_types.length > 0
      types = event_types.join(',')
      params = params.merge({:type => types})
    end

    response = request("events", params)
    events = response['events']
    @log.debug("#{events.length()} events retrieved")

    # RubyMine is wrong - this is needed
    return events
  end

  def authenticate
    uri = "https://#{@client_id}:#{@client_secret}@api.cloudpassage.com/oauth/access_token?grant_type=client_credentials"

    begin
      response = RestClient.post uri, :params => "noop"
    rescue => e
      @log.error "Error authenticating to grid."
      @log.error e.to_s
      raise e
    end

    json = JSON.parse(response)
    @token = json["access_token"]
    @token_expires = Time.now + json["expires_in"]


    if json["scope"] != "read"
      @log.warn("Token scope is not read-only. It is better to use a read-only token for New Relic.")
    end
  end

  def request(resource, params)
    uri = HALO_URI + resource

    if @token_expires.nil? || Time.now > @token_expires
      @log.debug "Token expired, re-authenticating."
      authenticate
    end

    @log.debug ("Performing api call to: #{uri}")
    params = params.merge({:per_page => 100})
    @log.debug("Params: #{params}")

    begin
      response = RestClient.get uri, :params => params, :Authorization => "Bearer #{@token}", :accept => :json
    rescue => e
      @log.error "Error hitting Halo API"
      @log.error e.to_s
      exit 1
    end

    json = JSON.parse(response)
  end

end