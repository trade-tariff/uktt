# UKTT

UKTT provides a way to work with the UK Trade Tariff API, https://api.trade-tariff.service.gov.uk/.

###  Features

- Fetches sections, chapters, headings, commodities, goods_nomenclatures, monetary exchange rates, and quota definitions from the Tariff API
- Tests local, production, and any other Frontend API servers using real (not mocked) API calls

## Installation

Add to your Gemfile:

```ruby
gem 'uktt'
```

## Usage

Set options in the http client and pass the client to different resources

```ruby
# Instantiate a new http client with options:
host =  'http://localhost:3002', # use a local frontend server
version =  'v2',                 # `v1` and `v2` are supported
debug =  false,                  # dislays request and response info
connection = nil                 # Pass a Faraday connection object to inject middleware or leave default configuration with nil

client = Uktt::Http.new(host, version, debug, connection)

# Fetch a single section or all sections
section_id = '1'
section = Uktt::Section.new(client)
response = section.retrieve(section_id)
response = section.retrieve_all
````

## Development

While developing the gem, and for use outside of a Rails app, I found it useful to have a console:

```bash
$ bundle console
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` (or `bundle console` outside of a rails app) for an interactive prompt that will allow you to experiment.

## Contributing

Code: https://github.com/trade-tariff/uktt.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `uktt` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/trade-tariff/uktt/blob/master/CODE_OF_CONDUCT.md).
