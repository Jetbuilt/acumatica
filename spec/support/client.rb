def configure_client
  Acumatica::Client.configure do |config|
    config.url = ENV['ACUMATICA_URL']
    config.name = ENV['ACUMATICA_USER']
    config.password = ENV['ACUMATICA_PASSWORD']
  end
end
