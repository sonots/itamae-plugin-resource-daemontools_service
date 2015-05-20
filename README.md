# Itamae::Plugin::Resource::DaemontoolsService

[Itamae](https://github.com/itamae-kitchen/itamae) resource plugin to manage daemontools service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'itamae-plugin-resource-daemontools_service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itamae-plugin-resource-daemontools_service

## Usage

```ruby
require "itamae/plugin/resource/daemontools_service"

# ln -s /etc/djbdns/tinydns-internal /service/tinydns-internal
# svc -u /service/tinydns-internal
daemontools_service "tinydns-iternal" do
  directory '/etc/djbdns/tinydns-internal'
  action [:enable, :start]
end
```

Options:

- directory (required)
    - directory contains `run` file. This directory is symlinked. 
- service_dir (option)
    - directory that svscan monitors. default is `/service`
- svc_command (option)
    - the path of the svc command. default is `svc`
- svstat_command (option)
    - the path of the svstat command. default is `svstat`

## Acknowledgement

This is an itamae plugin version of https://github.com/hirose31/chef-provider-service-daemontools. Thanks!

## Contributing

1. Fork it ( https://github.com/k0kubun/itamae-plugin-resource-daemontools_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
