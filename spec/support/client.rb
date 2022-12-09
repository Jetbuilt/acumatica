# frozen_string_literal: true

def configure_client
  Acumatica::Client.configure do |config|
    config.url      = ENV.fetch('ACUMATICA_URL')
    config.name     = ENV.fetch('ACUMATICA_USER')
    config.password = ENV.fetch('ACUMATICA_PASSWORD')
  end
end
