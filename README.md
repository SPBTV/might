# MightyFetcher

Mighty Fetcher utilizes the power of Ransack gem to provide models gathering api for Rails' controllers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mighty_fetcher'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mighty_fetcher

## Usage

Define a Mighty Fetcher

```ruby
class ChannelFetcher < MightyFetcher::Base
  # Specify resource to be fetched
  self.resource_class = Channel

  # Specify list of allowed filters
  filter :genres_name

  # Allowed sortings
  sort :name
  sort :created_at

  # Allow to search on model using Postgres Search
  search
end
```

And fetch resources by user input:

```ruby
ChannelFetcher.run(
  'filter' => {
    'genres_name_in' => 'Horror,Drama',
  },
  'sort' => '-created_at,name',
  'page' => {
    'limit' => 50,
    'offset' => 0
  },
  'search' => 'Hot'
)
```

`params` hash should follow the following conventions:

* `:filter` key is used for filtering
* `:sort` key is used for sorting
* `:page` key is used for pagination

### Configuring filters

To filter resources using Mighty Fetcher you should provide white list of allowed filters.
Internally it uses [Ransack](https://github.com/activerecord-hackery/ransack) gem, so consult with its documentation
in case of frustration.


Simplest filter definition looks as follows:

```ruby
filter :name
```

It allows client to filter collection on its name. So if a client want to
 filter on exec name it should pass a hash containing `name` followed by `_eq` predicate:

```ruby
ChannelFetcher.run(
  'filter' => {
    'name_eq' => 'MTV'
  }
)
```

If you need to pass list of values, specify them as comma separated list:

```ruby
ChannelFetcher.run(
  'filter' => {
    'name_in' => 'MTV,A-One'
  }
)
```

You may provide alias for an attributes using `:as` option

```ruby
filter :name, as: :title
```

The `Channel#name` attribute would be exposed as `title` to the fetcher api.

```ruby
ChannelFetcher.run(
  'filter' => {
    'title_eq' => 'MTV'
  }
)
```

Using power of Ransack we can filter of relations' attributes. For instance
to search for channels on languages with specified iso2 code, you have two options.

```ruby
filter :language_iso2
```

Query on this attribute as is and Ransack will handle all details:

```ruby
ChannelFetcher.run(
  'filter' => {
    'language_iso2_eq' => 'ru'
  }
)
```

The second option is:

```ruby
filter :iso2, on: :language
```

```ruby
ChannelFetcher.run(
  'filter' => {
    'iso2_eq => 'ru'
  }
)
```

It's possible to coerce attribute before using it:

```ruby
filter :resource_type, coerce: ->(value) { String(value).classify }
```

You can whitelist predicates for each filter:

```ruby
filter id: [:in, :eq]
filter name: :eq
```

Filtering on polymorphic association needs more configuration.

```ruby
class House < ActiveRecord::Base
  has_one :location, as: :locatable
end

class Location < ActiveRecord::Base
  belongs_to :locatable, polymorphic: true
end

class LocationFetcher < MightyFetcher::Base
  filter :locatable_id, on: { resource: ['House'] }
end
```

User provided filters may be validated using `ActiveModel::Validation`

```ruby
filter registration_number: :eq, validates: { length: { is: 6 } }
```

If value of the `registration_number` is invalid it raises `MightyFetcher::FilterValidationFailed`.

#### List of all supported predicates

Predicate      | Opposite Predicate | Meaning
--------------:|-------------------:|-----------------------------------------------------
`eq`           | `not_eq`           | field is exactly equal to a given value
`matches`      | `does_not_match`   | field is like a given value
`lt`           | `gt`               | field is less than a given value
`lteq`         | `gteq`             | field is less than or equal to a given value
`in`           | `not_in`           | field is within a specified list
`cont`         | `not_cont`         | field contains a given value
`cont_any`     | `not_cont_any`     | field contains any of given values
`start`        | `not_start`        | field begins with a given value
`end`          | `not_end`          | field ends with a given value
`true`         | `not_true`         | field is true
`false`        | `not_false`        | field is false
`present`      | `blank`            | field is present (not null and not a blank string)
`null`         | `not_null`         | field is null


### Configuring sorting

Mighty Fetcher supports sorting resource collections according to one or more criteria.

```ruby
sort :name
sort :created_at
```

To sort on one of the allowed fields provide `sort` parameter:

```ruby
ChannelFetcher.run('sort' => 'name')
```

If you need to sort against multiple fields separate them with comma. Sort fields would be applied
in the order specified.

```ruby
ChannelFetcher.run('sort' => 'name,created_at')
```

The sort order for each sort field is ascending unless it is prefixed with a minus, in which case it is descending.

```ruby
ChannelFetcher.run('sort' => '-created_at,name')
```

The above example should return the newest channels first. Any articles created on the same date will then
be sorted by their name in ascending alphabetical order.

### Configuring components

Mighty Fetcher implements it's components as chain of middlewares (Using [ibsciss-middleware](https://github.com/Ibsciss/ruby-middleware))

You can disable sorting, pagination and filtering altering middleware chain.

```ruby
class ChannelFetch < Fetch
  middleware.delete MightyFetcher::Middleware::Filter
  middleware.insert_before MightyFetcher::Middleware::Sort, CustomFilterMiddleware
  middleware.use AnotherMiddleware
end
```

If you need do perform some actions before or after middleware chain:

```ruby
class FavoritesFetcher < MightyFetcher::Base
  before do |favorites, params|
    [favorites.by_user(params[:user]), params]
  end
end
```

```ruby
class AccessesFetcher < MightyFetcher::Base
  after do |resources|
    resources.map { |r| Access.new(r) }
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a
new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem`
file to [rubygems.org](https://rubygems.org).
