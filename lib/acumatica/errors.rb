# frozen_string_literal: true

require 'faraday'

module Acumatica
  class ErrorHandler < Faraday::Middleware
    def initialize(app)
      super(app)
      @parser = nil
    end

    def call(request_env)
      @app.call(request_env).on_complete do |env|
        case env[:status]
        when 400, 412, 422
          raise Acumatica::BadRequest, env
        when 401, 403
          raise Acumatica::Unauthorized, env
        when 429
          raise Acumatica::TooManyRequests, env
        when 500
          raise Acumatica::InternalServerError, env
        end
      end
    end
  end

  class Error < StandardError
    def initialize(env = {})
      super(error_message(env))
    end

    def error_message(env)
      env[:body]["error"]
    end
  end

  class BadRequest < Error
  end

  class Unauthorized < Error
  end

  class TooManyRequests < Error
  end

  class InternalServerError < Error
    def error_message(env)
      env[:body]["exceptionMessage"]
    end
  end
end
