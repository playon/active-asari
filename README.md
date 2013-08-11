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

The domain is the top most element in the structure.  The example above specifies two domains.  The first one has indexes for name,  amount,  last_updated and bee_larvae_type.  All active_asari fields are result enabled to allow you to retrive the result values from Amazon Cloud search.  The index_field_type specifies the Amazon Cloud Search unit type.  search_enabled specifies your ability to search on a field.  text fields are always searchable,  uint are configurable but default to searchable and literals need to be enabled if you want to be able to search them.  

The ActiveAsari::Migrations class has methods to 'migrate' your cloud search instance to have domains with indexes specified in your config file.  We have a todo to add rake tasks to the gem.  In the meantime you can all migrate_all to create everything in your configuration file or migrate_domain to migrate one domain.  Both of these commands also apply to access policies you specified in your env file.  When the domain is created,  the prefix you specified is added to the domain and it is uncased similar to rails but instead of using underscores it uses -.  For example HoneyBadger in the development environment with a prefix of dev would create a domain called dev-honey-badger.

#### Your Models

Any model can be associated with a ActiveAsari Object.  This is done by adding the following three lines to the beginning of your model class.

    include ActiveAsari::ActiveRecord
    include Asari::ActiveRecord if !env_test?
    active_asari_index 'YourDomain'

You would substitute the appropriate domain specified in your config file.  The !env_test option was the only way to not have ActiveAsari not interfere with tests.  We would welcome pull requests to make this cleaner.

Once you have this in your model,  and have run your migrations all update,  create and deletes to the model in a non_test environment will automatically be performed in AmazonCloud search keeping the two environments in sync.

#### Searching 

Searching is done via ActiveAsari.active_asari_search.  IE:

    ActiveAsari.active_asari_search 'HoneyBadger', 'name:beavis',  :query_type => :boolean

The query_type allows you to specify if you want to do a boolean or regular query.  All other options are passed directly to asari,  so see the asari gem for documentation on how to use it.  Results are automatically returned in a hash of objects indexed by the document_id.  The object contains a raw_result accessor along with accessors for all returned fields in the hash.  So...

    my_result = ActiveAsari.active_asari_search 'HoneyBadger', 'beavis'
    my_result['6'].name.should include 'beavis'

Search parameters are passed directly to Amazon Cloud Search.  See it's documentation for otpions,  syntax etc..


## Contributions 

If ActiveAsari interests you,  please fork the repo and submit a pull request.  

### Contributors 

* [Lance Gleason](https://github.com/lgleasain "lgleasain on Github")

## License 

MIT,  see LICENSE for more details.

