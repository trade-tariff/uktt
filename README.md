# UKTT

UKTT is a Ruby client for the UK Trade Tariff API. It fetches sections, chapters,
headings, commodities, goods nomenclatures, exchange rates and quota definitions.
It also includes specs that make real requests to a configured tariff API.

For API consumers, start with the
[Trade Tariff API documentation](https://docs.trade-tariff.service.gov.uk/).

## Install

Add the gem to your application's Gemfile and run `bundle install`:

```ruby
gem 'uktt'
```

## Use the client

Pass the API root to the HTTP client. The local backend's UK API root includes
`/uk/api`, not `/api/uk`:

```ruby
require 'uktt'

host = 'http://localhost:3000/uk/api'
client = Uktt::Http.build(host)
section = Uktt::Section.new(client)

response = section.retrieve('1')
response = section.retrieve_all
```

The backend must be running and contain data for the resources you request.
See [lib/uktt/](lib/uktt/) for the supported resource clients.

## Develop and check changes

Use Ruby and Bundler with the versions required by [uktt.gemspec](uktt.gemspec)
and [Gemfile](Gemfile). From the repository root:

```sh
bundle install
bundle exec rake spec
```

Some specs make real HTTP requests. The shared HTTP context in
[spec/spec_helper.rb](spec/spec_helper.rb) targets the staging tariff service.
Check the target and access requirements before running the suite. It is not an
entirely offline test suite. Use `bundle console` for an interactive Ruby session.

## Contribute

Read [CONTRIBUTING.md](CONTRIBUTING.md) for the fork workflow, checks and private
security reporting. Follow the [code of conduct](CODE_OF_CONDUCT.md).

## Licence

The gem uses the [MIT licence](LICENSE.txt), including Christopher Unger's
copyright notice. Preserve that notice when reusing the code. API data and
third-party dependencies retain their own terms.
