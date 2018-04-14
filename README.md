# Acumatica

This gem provides a wrapper for the [Acumatica REST API](https://help.acumatica.com/Main?ScreenId=ShowWiki&pageid=ca2716f1-025a-4a6e-9090-797cf32b0459).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acumatica'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acumatica

## Usage

```
acumatica = Acumatica::Client.configure do |config|
  config.url = "https://mycompany.acumatica.com"
  config.name = "user@company"
  config.password = "sekret"
end

acumatica.login

acumatica.stock_items.find_all(
  select: 'Attributes,InventoryID',
  filter: '',
  offset: 0,
  limit:  100,
  expand: 'Attributes'
)

acumatica.stock_items.create({
  "InventoryID": { "value": "TEST" },
  "Description": { "value": "Test Item" },
  "Attributes": [
    {
      "AttributeID": { "value": "Manufacturer" },
      "Value":       { "value": "ACME" }
    }
  ]
})

acumatica.logout
```    

## NOTES
- Currently only querying and creating StockItems has been implemented - pull requests welcome!
- Querying Acumatica can be very slow, account for that when designing your integration.
- Some Acumatica installations limit the number of concurrent users, so make sure to logout when finished.

## TODO
- OAuth Authentication (coming soon)
- Tests

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jetbuilt/acumatica. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting with this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jetbuilt/acumatica/blob/master/CODE_OF_CONDUCT.md).
