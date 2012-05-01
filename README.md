# Bitmask

Bitmask represents a set of boolean values as an Integer.

This bitmask gem was extracted from [amiel/has_bitmask_attributes](https://github.com/amiel/has_bitmask_attributes)

## Installation

Add this line to your application's Gemfile:

    gem 'bitmask'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitmask

## Usage


Examples:

```ruby
  masks = {
            :cat  => 0b0001,
            :dog  => 0b0010,
            :fish => 0b0100,
          }

  bitmask = Bitmask.new(masks, {:cat => true})
  bitmask.to_i            # => 1
  bitmask.get :cat        # => true
  bitmask.get :dog        # => false
  bitmask.set :dog, true
  bitmask.get :dog        # => true
  bitmask.to_i            # => 3
  bitmask.to_h            # => { :cat => true, :dog => true, :fish => false }

  bitmask = Bitmask.new(masks, 0b101)
  bitmask.to_h            # => { :cat => true, :dog => false, :fish => true }
  bitmask.to_i            # => 5
  bitmask.to_i.to_s(2)    # => "101"

  Bitmask.new(masks, 5) == Bitmask.new(masks, { :cat => true, :dog => false, :fish => true }) # => true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
