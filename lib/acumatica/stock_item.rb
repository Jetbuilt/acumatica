module Acumatica
  class StockItem < OpenStruct
    def self.find_all(select: nil, filter: nil, expand: nil, offset: nil, limit: nil)
      params = {}

      params['$select'] = select if select
      params['$filter'] = filter if filter
      params['$expand'] = expand if expand
      params['$offset'] = offset if offset
      params['$top']    = limit  if limit

      response = Acumatica::Client.instance.connection.get do |req|
        req.url url
        req.params = params
      end

      response.body.map { |attrs| self.new(attrs) }
    end

    def self.url
      URI.join(
        Acumatica::Client.instance.url,
        "/entity/Default/#{Acumatica::Client::API_VERSION}/StockItem"
      )
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

    def methodify(word)
      word.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end
  end
end
