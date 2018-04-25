require "active_support/core_ext/string/inflections"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/hash/transform_values"
require "ostruct"

module Acumatica
  class Resource < OpenStruct
    def self.create(attrs = {})
      response = Acumatica::Client.instance.connection.put do |req|
        req.url url
        req.body = format_params(attrs) if attrs
      end

      self.new(response.body)
    end

    def self.find_all(select: nil, filter: nil, expand: nil, offset: nil, limit: nil)
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

      response.body.map { |attrs| self.new(attrs) }
    end

    def self.url
      URI.join(Acumatica::Client.instance.base_url, self.to_s.split("::").last)
    end

    def initialize(params = {})
      new_params = {}
      params.each do |k,v|
        v = v.values.first if v.is_a?(Hash) && v.keys == ["value"]
        new_params[methodify(k)] = v
      end

      super(new_params)

      self.attributes ||= []
      attributes.each { |a| self[methodify(a['AttributeID']['value'])] = a['Value']['value'] }
    end

    private

    def methodify(string)
      string.underscore.parameterize(separator: '_')
    end

    def self.format_params(attrs)
      attrs.transform_keys!{ |key| key.to_s.camelize }
      attrs.transform_values!{ |value| value.is_a?(String) ? { "value" => value } : value }
      attrs
    end
  end
end
