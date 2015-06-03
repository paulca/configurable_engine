# Configurable [![Build Status](https://travis-ci.org/paulca/configurable_engine.png?branch=master)](https://travis-ci.org/paulca/configurable_engine)

A Rails 3/4 configuration engine. An update to [Behavior](http://github.com/paulca/behavior) for Rails 3 and 4.

## How it works ##

Configurable lets you define app-wide configuration variables and values in `config/configurable.yml`. These can then be accessed throughout your app.

If you or your app users need to change these variables, Configurable stores new values in the database.

## Installation ##

Configurable is available as a Ruby gem. Simply add it to your Rails 3 app's `Gemfile`:

```ruby
gem 'configurable_engine'
```

Then run the `configurable_engine:install` generator:

```bash
$ rails generate configurable_engine:install
```

## Usage ##

There are two parts to how configurable_engine works. First of all there is a config file, config/configurable.yml. This file controls the variables that are allowed to be set in the app.

For example, if you wanted to have access to a config variable "site_title", put this in configurable.yml:

```yaml
site_title:
  name: Site Title
  default: My Site
  # type: String is the default
```
Now, within your app, you can access `Configurable[:site_title]` (or `Configurable.site_title` if you prefer).

Since Configurable is an ActiveRecord model, if you want to update the config, create a Configurable record in the database:

```ruby
Configurable.create!(:name => 'site_title', :value => 'My New Site')
```
You can set the `type` attribute to `boolean`, `decimal`,`integer`, or `list` and it will treat those fields as those types.  Lists are comma and/or newline delimeted arrays of strings.

## Web Interface ##

Configurable comes with a web interface that is available to your app straight away at `http://localhost:3000/admin/configurable`.

If you want to add a layout, or protect the configurable controller, create `app/controllers/admin/configurables_controller.rb` as such:

```bash
$ bundle exec rails generate controller admin/configurables
```

and include `ConfigurableEngine::ConfigurablesController`, eg.

```ruby
class Admin::ConfigurablesController < ApplicationController
  # include the engine controller actions
  include ConfigurableEngine::ConfigurablesController

  # add your own filter(s) / layout
  before_filter :protect_my_code
  layout 'admin'
end
```

To ensure text areas are rendered correctly, ensure that your layout preserves whitespace.  In haml, use the `~` operator

```haml
  %container
    ~ yield
```

If you want to control how the fields in the admin interface appear, you can add additional params in your configurable.yml file:

```yaml
site_title:
  name: Name of Your Site   # sets the edit label
  default: My Site          # sets the default value
  type: string              # uses input type="text"
site_description:
  name: Describe Your Site  # sets the edit label
  default: My Site          # sets the default value
  type: text                # uses textarea
secret:
  name: A Secret Passphrase # sets the edit label
  default: passpass         # sets the default value
  type: password            # uses input type="password"

Value:
  name: A number            # sets the edit label
  default: 10               # sets the default value
  type: integer             # coerces the value to an integer

Price:
  name: A price             # sets the edit label
  default: "10.00"          # sets the default value
  type: decimal             # coerces the value to a decimal
```

## Cacheing ##

If you want to use rails caching of Configurable updates, simply set

```ruby
config.use_cache = true
```

in your `config/application.rb` (or `config/production.rb`)

## Translating the interface ##

### Labels ###

If you want labels in your admin interface to be translated, just set a `i18n_key` option for your configuration:

```
Price:
  name: A price                # sets the edit label
  default: "10.00"             # sets the default value
  type: decimal                # coerces the value to a decimal
  i18n_key: configurable.price # this will call I18n.t('configurable.price') to display the label
```

In this case the `name` label won't be used in the admin interface.

### Title ###

You can translate the title of the page by setting a translation for the key `configurable.admin_title`:

```
# example config/locales/en.yml
...
configurable:
  admin_title: My cool app configuration
...
```

### Submit button ###

Same as title, but the key is `configurable.submit_button`.


## Styling the interface ##

To style the web interface you are advised to use Sass. Here's an example scss file that will make the interface bootstrap-3 ready:

```
@import 'bootstrap';

.configurable-container {
  @extend .col-md-6;

  .configurable-options {
    form {
      @extend .form-horizontal;

      .configurable {
        @extend .col-md-12;
        @extend .form-group;

        textarea, input[type=text], input[type=password] {
          @extend .form-control;
        }
      }

      input[type=submit] {
        @extend .btn;
        @extend .btn-primary;
      }
    }
  }
}

```

Just save this into your rails assets and you're ready to go.

## Running the Tests ##

The tests for this rails engine are in the `spec` and `features` directories.  They use the dummy rails app in `spec/dummy`

From the top level run:

```bash
$ bundle exec rake app:db:schema:load
$ bundle exec rake app:db:test:prepare
$ bundle exec rake
```

## Contributing ##

All contributions are welcome. Just fork the code, ensure your changes include a test, ensure all the current tests pass and send a pull request.

## Copyright ##

Copyright (c) 2011 Paul Campbell. See LICENSE.txt for
further details.

