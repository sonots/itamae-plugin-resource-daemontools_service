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

# sync test scripts
directory "/tmp/service"

remote_directory "/tmp/service/test/" do
  source "files/tmp/service/test/"
end

# tests

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:enable]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:enable]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:start]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:start]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:reload]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:reload]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:stop]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:stop]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:restart]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:restart]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:disable]
end

daemontools_service "test" do
  directory "/tmp/service/test"
  action [:disable]
end
