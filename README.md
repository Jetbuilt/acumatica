# Acumatica

This gem provides a wrapper for the [Acumatica REST API](https://help.acumatica.com/Main?ScreenId=ShowWiki&pageid=ca2716f1-025a-4a6e-9090-797cf32b0459).


![Travis](https://img.shields.io/travis/Jetbuilt/acumatica.svg)

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

### Client

```
acumatica = Acumatica::Client.configure do |config|
  config.url = "https://mycompany.acumatica.com"
  config.name = "user@company"
  config.password = "sekret"
end

# Manually log in/out
acumatica.login
acumatica.stock_items.find_all(limit: 1)
acumatica.logout

# Wrap calls in session to automatically log in/out
acumatica.session do
  acumatica.stock_items.find_all(
    select: 'Attributes,InventoryID',
    filter: '',
    offset: 0,
    limit:  100,
    expand: 'Attributes'
  )
end
```    

### StockItem

```
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
```

### Customer

```
acumatica.customers.find_all(limit: 1)
acumatica.customers.create(customer_id: "123", customer_name: "ACME", tax_zone: "TAXES!")
```

## NOTES
- This library is very much a work in progress - pull requests welcome!
- Querying Acumatica can be very slow, account for that when designing your integration. For
  example, calling `find_all` on a resource without a limit may take minutes to complete the
  request. YMMV.
- Some Acumatica installations limit the number of concurrent users, so make sure to logout when
  finished or wrap calls with `Acumatica::Client#session`

## TODO
- OAuth Authentication (coming soon)
- Document public methods

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jetbuilt/acumatica. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting with this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jetbuilt/acumatica/blob/master/CODE_OF_CONDUCT.md).
