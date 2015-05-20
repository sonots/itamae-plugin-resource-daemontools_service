require 'itamae/plugin/resource/daemontools_service'

# install daemontools
package 'daemontools'

remote_file "/etc/init/svscan.conf" do
  owner "root"
  group "root"
end

execute "start svscan" do
  command [
    "initctl reload-configuration",
    "initctl start svscan"
  ].join("\n")
  not_if "initctl status svscan | grep running"
end

directory "/tmp/service"

%w[with_log without_log].each do |_service|
  # sync test scripts
  remote_directory "/tmp/service/#{_service}/" do
    source "files/tmp/service/#{_service}/"
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:enable]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:enable]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:start]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:start]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:reload]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:reload]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:stop]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:stop]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:restart]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:restart]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:disable]
  end

  daemontools_service "#{_service}" do
    directory "/tmp/service/#{_service}"
    action [:disable]
  end
end
