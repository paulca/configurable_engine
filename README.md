# Configurable [![Build Status](https://travis-ci.org/paulca/configurable_engine.png?branch=master)](https://travis-ci.org/paulca/configurable_engine)

A Rails 3 configuration engine. An update to [Behavior](http://github.com/paulca/behavior) for Rails 3.

## How it works ##

Configurable lets you define app-wide configuration variables and values in `config/configurable.yml`. These can then be accessed throughout your app.

If you or your app users need to change these variables, Configurable stores new values in the database.

## Installation ##

Configurable is available as a Ruby gem. Simply add it to your Rails 3 app's `Gemfile`:

    gem 'configurable_engine'

Then run the `configurable_engine:install` generator:

    rails generate configurable_engine:install

## Usage ##

There are two parts to how configurable_engine works. First of all there is a config file, config/configurable.yml. This file controls the variables that are allowed to be set in the app.

For example, if you wanted to have access to a config variable "site_title", put this in configurable.yml:

    site_title:
      name: Site Title
      default: My Site
  
Now, within your app, you can access `Configurable[:site_title]` (or `Configurable.site_title` if you prefer).

Since Configurable is an ActiveRecord model, if you want to update the config, create a Configurable record in the database:

    Configurable.create!(:name => 'site_title', :value => 'My New Site')
    
## Web Interface ##

Configurable comes with a web interface that is available to your app straight away at `http://localhost:3000/admin/configurable`.

If you want to add a layout, or protect the configurable controller, create `app/controllers/admin/configurables_controller.rb` as such:

    bundle exec rails generate controller admin/configurables

and include `ConfigurableEngine::ConfigurablesController`, eg.

    class Admin::ConfigurablesController < ApplicationController
      # include the engine controller actions
      include ConfigurableEngine::ConfigurablesController
    
      # add your own filter(s) / layout
      before_filter :protect_my_code
      layout 'admin'
    end

If you want to control how the fields in the admin interface appear, you can add additional params in your configurable.yml file:

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

## Running the Tests ##

The tests for this rails engine are in the `spec` and `features` directories.  They use the dummy rails app in `spec/dummy`

From the top level run:

    $ bundle exec rake app:db:schema:load app:db:test:prepare
    $ bundle exec rake
    
## Contributing ##

All contributions are welcome. Just fork the code, ensure your changes include a test, ensure all the current tests pass and send a pull request.

## Copyright ##

Copyright (c) 2011 Paul Campbell. See LICENSE.txt for
further details.

