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
  
There are two configuration files that active_asari looks for.  First,  active_asari_env.yml.  Right now this file is used to configure access permissions for your domains and the prefix to use for them.  Prefixing was added so that you can have domains for multiple environments under one amazon account without having them stomp on each other.  Here is an example of a active_asari_env.yml file.

    development:
      domain_prefix: dev
      access_permissions:
      - ip_address: 0.0.0.0/0  
      - ip_address: 25.44.23.25/32
    staging:
      domain_prefix: staging
      access_permissions:
      - ip_address: 192.168.66.23/32  
      - ip_address: 28.44.23.25/32

When you are in a test environment active_asari overlays are disabled.  Right now the recommended way of testing asari calls is via mocking.

#### Your Domain

Domains are collections of data that you can store.  ActiveAsari has taken the approach of associating a activerecord table with a domain.  So if you have a talble called events then you might create a domain of the same name.  Domain objects are specified in the active_asari_config.yml file.  Below is an example of a file.

    TestModel:
      name: 
        index_field_type: text
        search_enabled: true
      amount: 
        index_field_type: uint
        search_enabled: true
      last_updated:
        index_field_type: uint
        search_enabled: false
      bee_larvae_type:
        index_field_type: literal
    HoneyBadger:
      name:
        index_field_type: text 


