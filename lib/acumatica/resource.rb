# frozen_string_literal: true

require "active_support/core_ext/string/inflections"
require "active_support/core_ext/hash/keys"
require "ostruct"

module Acumatica
  class Resource < OpenStruct
    class << self
      def create(body = {}, params = {})
        response = Acumatica::Client.instance.connection.put do |req|
          req.url url
          req.body = format_request_body(body) if body
          req.params = parse_query_params(params) if params
        end

        new(response.body)
      end

      def find_all(params = {})
        response = Acumatica::Client.instance.connection.get do |req|
          req.url url
          req.params = parse_query_params(params) if params
        end

        response.body.map { |attrs| new(attrs) }
      end

      def url
        URI.join(Acumatica::Client.instance.base_url, to_s.split("::").last)
      end

      private

      def deep_transform_values!(object)
        case object
        when Array
          object.map! { |e| deep_transform_values!(e) }
        when Hash
          object.each do |key, value|
            object[key] = deep_transform_values!(value)
          end
        else
          { "value" => object }
        end
      end

      def format_request_body(body_hash)
        body = body_hash.deep_transform_keys { |key| key.to_s.camelize.gsub("Id", "ID") }
        deep_transform_values!(body)
      end

      def parse_query_params(params)
        query_params = {}

        query_params['$select'] = params[:select] if params[:select]
        query_params['$filter'] = params[:filter] if params[:filter]
        query_params['$expand'] = params[:expand] if params[:expand]
        query_params['$skip']   = params[:offset] if params[:offset]
        query_params['$top']    = params[:limit]  if params[:limit]
        query_params
      end
    end

    def initialize(params = {})
      super(format_params(params))
      format_attributes!
    end

    private

    def format_params(params)
      new_params = params.transform_keys { |k| methodify(k) }
      new_params.transform_values! { |v| v.is_a?(Hash) && v.keys == ["value"] ? v.values.first : v }
    end

    def format_attributes!
      self.attributes ||= []
      attributes.each { |a| self[methodify(a['AttributeID']['value'])] = a['Value']['value'] }
    end

    def methodify(string)
      string.underscore.parameterize(**methodify_separator)
    end

    def methodify_separator
      @methodify_separator ||=
        if Gem.loaded_specs["activesupport"].version < Gem::Version.create("5.0.0")
          '_'
        else
          { separator: '_' }
        end
    end
  end
end
