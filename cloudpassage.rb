require 'yaml'


module CloudPassage

	class HaloConnection
		attr_accessor :client_id
		attr_accessor :client_secret

		# Read the settings
		def initialize
			settings = YAML.load_file("config/newrelic_plugin.yml")
			@client_id = settings.agents.cloudpassage.client_id
			@client_secret = settings.agents.cloudpassage.client_secret
		end


		private
		def authenticate
			uri = "https://#{@client_id}:#{@client_secret}@api.cloudpassage.com/oauth/access_token?grant_type=client_credentials"

			begin
				response = RestClient.post uri, :params => "noop"
			rescue => e
			    $log.error "Error authenticating to grid."
			    $log.error e.to_s
			    exit 1
			end

			json = JSON.parse(response)
			$token = json["access_token"]
			$token_expires = Time.now + json["expires_in"]
			$token_read_only = json["scope"] == "read"

			$log.debug ("Token: #{$token}")

			scope = json["scope"]
			expires = json["expires_in"]
			$log.info "Retrieved #{scope} token valid for #{expires} seconds."
		end
	end
end