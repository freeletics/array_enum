[![Gem Version](https://badge.fury.io/rb/array_enum.svg)](https://badge.fury.io/rb/array_enum)
[![BUILD](https://github.com/freeletics/array_enum/actions/workflows/ci-on-merge.yml/badge.svg)](https://github.com/freeletics/array_enum/actions/workflows/ci-on-merge.yml)


# ArrayEnum

Extension for `ActiveRecord` that adds support for `PostgreSQL` array columns, mapping string values to integers.

## Installation

`gem install array_enum` or use `Gemfile` with bundler

## Usage

### ActiveRecord extension

Database will store integers that after reading will map to string values.

```ruby
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.integer :favourite_colors, array: true, null: false, default: []
  end
end

class User < ActiveRecord::Base
  extend ArrayEnum

  array_enum favourite_colors: {"red" => 1, "blue" => 2, "green" => 3}
end

user = User.create!(favourite_colors: ["red", "green"])
user.favourite_colors # => ["red", "green"]
User.favourite_colors # => {"red" => 1, "blue" => 2, "green" => 3}
```

Several scopes are made available on your model to find records based on a value or an array of values:

```ruby
user1 = User.create!(favourite_colors: ["red", "green"])
user2 = User.create!(favourite_colors: ["red"])

# Find a record that has _all_ the provided values in the array enum attribute
User.with_favourite_colors("red") # => [user1, user2]
User.with_favourite_colors(%w[red green]) # => [user1]
User.with_favourite_colors(%w[red blue]) # => []
User.with_favourite_colors(%w[green blue]) # => []

# Find a record that has the provided values, and _only those values_, in the array enum attribute
User.only_with_favourite_colors("red") # => [user2]
User.only_with_favourite_colors(%w[red green]) # => [user1]
User.only_with_favourite_colors(%w[red blue]) # => []
User.only_with_favourite_colors(%w[green blue]) # => []

# Find a record that has _at least one_ of the provided values in the array enum attribute
User.with_any_of_favourite_colors("red") # => [user1, user2]
User.with_any_of_favourite_colors(%w[red green]) # => [user1, user2]
User.with_any_of_favourite_colors(%w[red blue]) # => [user1, user2]
User.with_any_of_favourite_colors(%w[green blue]) # => [user1]
```

Attempting to find a record with a value that is not in the enum will fail:

```ruby
User.with_favourite_colors("yellow") # => ArgumentError["yellow is not a valid value for favourite_colors"]
```

### Subset Validator

Additionally `subset` validator is provided that can help to ensure correct values are passed during validation.

```ruby
class CreateUser
  include ActiveModel::Model

  attr_accessor :favourite_colors

  validates :favourite_colors, subset: ["green", "blue"]
  # or:
  # validates :favourite_colors, subset: { in: ->(record) { Color.pluck(:name) } }
end

CreateUser.new(favourite_colors: ["black"]).valid? # => false
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/freeletics/array_enum.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
