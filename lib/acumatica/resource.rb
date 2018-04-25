# frozen_string_literal: true

require "active_support/core_ext/string/inflections"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/hash/transform_values"
require "ostruct"

module Acumatica
  class Resource < OpenStruct
    class << self
      def create(attrs = {})
        response = Acumatica::Client.instance.connection.put do |req|
          req.url url
          req.body = format_params(attrs) if attrs
        end

        new(response.body)
      end

      def find_all(select: nil, filter: nil, expand: nil, offset: nil, limit: nil)
        params = {}

        params['$select'] = select if select
        params['$filter'] = filter if filter
        params['$expand'] = expand if expand
        params['$skip']   = offset if offset
        params['$top']    = limit  if limit

        response = Acumatica::Client.instance.connection.get do |req|
          req.url url
          req.params = params
        end

        response.body.map { |attrs| new(attrs) }
      end

      def url
        URI.join(Acumatica::Client.instance.base_url, to_s.split("::").last)
      end

      private

      def format_params(attrs)
        attrs.transform_keys! { |key| key.to_s.camelize }
        attrs.transform_values! { |value| value.is_a?(String) ? { "value" => value } : value }
        attrs
      end
    end

    def initialize(params = {})
      super(format_params(params))
      format_attributes!
    end

    private

    def format_params(params)
      params.transform_keys!   { |k| methodify(k) }
      params.transform_values! { |v| v.is_a?(Hash) && v.keys == ["value"] ? v.values.first : v }
    end

    def format_attributes!
      self.attributes ||= []
      attributes.each { |a| self[methodify(a['AttributeID']['value'])] = a['Value']['value'] }
    end

    # translate keys that don't map directly
    KEY_MAP = { customer_id: 'CustomerID' }.freeze

    def methodify(string)
      string.underscore.parameterize(separator: '_')
    end
  end
end
