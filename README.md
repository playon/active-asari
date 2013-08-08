# ActiveAsari

## Description

Full Active Record Integration with Asari along with migration-like indexing and domain creation.  This makes using Amazon Cloud Search a lot easier in your rails application.

#### Why ActiveAsari?

Active Asari builds functionality on Asar which gives you a powerfull way to create and access Amazon Cloud Search instances and data.

## Usage

#### Configuration

Include the gem in your project.

  gem 'active_asari'

In your application.rb file or in the main part of your rack app.  NOTE:  The ActiveAsari.configure method needs a directory to be passed to it.  It will look for the configuration files and load them from this location.

  AWS.config({:access_key_id => 'your Amazon key id', :secret_access_key => 'your Amazon secret key'})
  require 'active_asari'
  ACTIVE_ASARI_CONFIG, ACTIVE_ASARI_ENV = ActiveAsari.configure(File.dirname(__FILE__))
  require 'active_asari/active_record'
  

#### Your Domain 
