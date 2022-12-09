# frozen_string_literal: true

require "faraday"
require "faraday_middleware"
require "faraday-cookie_jar"
require "singleton"

module Acumatica
  class Client
    include Singleton

    API_VERSION = "6.00.001"

    attr_accessor :url, :name, :password, :token, :debug

    def self.configure
      yield(instance)
      instance
    end

    def base_url
      @base_url ||= URI.join(url, "entity/Default/#{API_VERSION}/")
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.request :json

        if token
          conn.request :oauth2, token
        else
          conn.use :cookie_jar
        end
        conn.use Acumatica::ErrorHandler

        conn.response :json
        conn.response :logger, nil, bodies: true if debug
        conn.adapter Faraday.default_adapter
      end
    end

    def session
      login
      result = yield
      logout
      result
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

    def customers
      Acumatica::Customer
    end

    def sales_orders
      Acumatica::SalesOrder
    end

    def stock_items
      Acumatica::StockItem
    end
  end
end
