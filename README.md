# Cursive

NOTE: This gem is non-functional at the moment: An existing codebase is being
extracted into it.

Cursive is a declarative CSV rails responder, inspired by
ActiveModel::Serializers.  Complex models sometimes need features that a simple
to_csv can't handle, and shouldn't clutter up your models.

## Installation

Add this line to your application's Gemfile:

    gem 'cursive'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cursive

## Usage

```ruby

# app/controllers/locations_controller.rb

class LocationsController < ApplicationController
  respond_to :csv, :json

  def index
    @locations = Location.all
    respond_with @locations
  end
end


# app/serializers/cursive/locations_cursive_serializer.rb

class LocationsCursiveSerializer < Cursive::Serializer
  attribute :id
  attribute :href
  attribute :status, default: 'NORMAL'

  # Serializer methods take precedence over model methods
  def href
    polymorphic_path(object)
  end

  # By default, we render a header.  Turn that off.
  def render_header?
    false
  end

  def default_value(object, attribute)
    return 'NONE'
  end
end


```

## The Name

```bash
< /usr/share/dict/words tr A-Z a-z | grep '^c.*s.*v.*' | sort | uniq | less
```

## Contributing

1. Fork it ( http://github.com/mieko/cursive/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
