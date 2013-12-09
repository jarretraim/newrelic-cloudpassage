#! /usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "newrelic_plugin"
require_relative "halo"
require_relative "halo_events"

module CloudPassageAgent

  class Agent < NewRelic::Plugin::Agent::Base
    attr_accessor :halo

    agent_guid "com.rackspace.newrelic-cloudpassage"
    agent_version "1.0.0"
    agent_human_labels("CloudPassage Agent") { "Halo Security Events" }
    agent_config_options :client_id, :client_secret

    def poll_cycle
      log = Logger.new(STDOUT)
      log.level = Logger::DEBUG

      if @halo.nil?
        @halo = Halo.new
      end

      if @last_time.nil?
        events = HaloEvents.new(@halo.events())
      else
        events = HaloEvents.new(@halo.events(@last_time))
      end


      log.info("Getting events from #{@last_time} to #{Time.now}")

      #metric_name, units, value, opts = {}
      report_metric "Daemon/Compromised", "Agents", events.get_count("daemons_compromised")


      @last_time = Time.now
    end
  end

  # Register this agent with the component.
  NewRelic::Plugin::Setup.install_agent :cloud_passage, CloudPassageAgent

  # Launch the agent; this never returns.
  NewRelic::Plugin::Run.setup_and_run
end
