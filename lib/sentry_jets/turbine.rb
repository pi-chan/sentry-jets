require 'sentry-ruby'

module SentryJets
  class Turbine < ::Jets::Turbine
    initializer 'sentry.configure' do
      Raven.configure do |config|
        config.dsn = ENV['SENTRY_DSN']
        config.current_environment = ENV['SENTRY_CURRENT_ENV'] || Jets.env.to_s
        config.silence_ready = true

        if (rate = ENV['SENTRY_TRACES_SAMPLE_RATE'])
          config.traces_sample_rate = rate.to_f
        end
      end
    end

    on_exception 'sentry.capture' do |exception|
      Sentry.capture_message(exception)
    end
  end
end
