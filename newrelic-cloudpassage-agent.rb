#! /usr/bin/env ruby

require "rubygems"
require "bundler/setup"
require "newrelic_plugin"
require "cloudpassage"

module CloudPassageAgent

  class Agent < NewRelic::Plugin::Agent::Base

    agent_guid "com.rackspace.newrelic-cloudpassage"
    agent_version "1.0.1"
    agent_config_options :hertz  # frequency of the periodic functions
    agent_human_labels("CloudPassage Agent") { "Halo Events" }

    halo = Halo.new()

    def poll_cycle
      x = Time.now.to_f * hertz * Math::PI * 2
      report_metric "SIN",     "Value", Math.sin(x) + 1.0
      report_metric "COS",     "Value", Math.cos(x) + 1.0
      report_metric "BIASSIN", "Value", Math.sin(x) + 5.0
    end

  end

  # Register this agent with the component.
  NewRelic::Plugin::Setup.install_agent :cloud_passage, CloudPassageAgent

  # Launch the agent; this never returns.
  NewRelic::Plugin::Run.setup_and_run
end
