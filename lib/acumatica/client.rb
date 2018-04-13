module Acumatica
  class Client
    include Singleton

    API_VERSION = "6.00.001".freeze

    attr_accessor :url, :name, :password, :token

    def self.configure
      yield(instance)
      instance
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.request :json

        if token
          conn.request :oauth2, token
        else
          conn.use :cookie_jar
        end

        conn.response :json
        conn.adapter Faraday.default_adapter
      end
    end

    def login
      response = connection.post do |req|
        req.url URI.join(@url, "/entity/auth/login")
        req.body = { name: @name, password: @password }
      end
      response.success?
    end

    def logout
      connection.post(URI.join(@url, "/entity/auth/logout")).success?
    end

    def stock_items
      Acumatica::StockItem
    end
  end
end
