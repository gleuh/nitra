require 'cucumber/runtime'
module Cucumber
  class ResetableRuntime < Runtime
    # Cucumber lacks a reset hook like the one Rspec has so we need to patch one in...
    # Call this after configure so that the correct configuration is used to create the result set.
    def reset
      if defined?(Formatter::LegacyApi::Results)
        @filespecs = nil
        @features = nil
        @report = nil
        @summary_report = nil
        @formatters = nil
        @results = Formatter::LegacyApi::Results.new
      else
        @results = Results.new(@configuration)
        @loader = nil
      end
    end

    def failure?
      if defined?(super)
        super
      else
        results.failure?
      end
    end

    def scenarios(*args)
      if defined?(Formatter::LegacyApi::Results)
        report.runtime.find {|r| r.is_a? Formatter::LegacyApi::Adapter}.results.scenarios
      else
        super
      end
    end
  end
end
