#! /usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require "newrelic_plugin"

module ExampleAgent

  class Agent < NewRelic::Plugin::Agent::Base

    agent_guid "com.rackspace.newrelic-cloudpassage"
    agent_version "1.0.1"
    agent_config_options :hertz  # frequency of the periodic functions
    agent_human_labels("Example Agent") { "Synthetic example data" }

    def poll_cycle
      x = Time.now.to_f * hertz * Math::PI * 2
      report_metric "SIN",     "Value", Math.sin(x) + 1.0
      report_metric "COS",     "Value", Math.cos(x) + 1.0
      report_metric "BIASSIN", "Value", Math.sin(x) + 5.0
    end

  end

  #
  # Register this agent with the component.
  # The ExampleAgent is the name of the module that defines this
  # driver (the module must contain at least three classes - a
  # PollCycle, a Metric and an Agent class, as defined above).
  #
  NewRelic::Plugin::Setup.install_agent :example, ExampleAgent

  #
  # Launch the agent; this never returns.
  #
  NewRelic::Plugin::Run.setup_and_run

end
