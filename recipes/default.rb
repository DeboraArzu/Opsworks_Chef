# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis

version_number = node['redis']['version']

# sudo apt update
execute "apt-get update"

# sudo apt-get install build-essential
package "build-essential"

# sudo apt-get install tcl8.5
package "tcl8.5"

# wget http://download.redis.io/releases/redis-stable.tar.gz
# http://download.redis.io/releases/redis-5.0.4.tar.gz
remote_file "/tmp/redis-#{version_number}.tar.gz" do
  source "http://download.redis.io/releases/redis-#{version_number}.tar.gz"
  notifies :run, "execute[unzip_redis_archive]", :immediately
end

#unzip the archive
execute "unzip_redis_archive" do
  command "tar xzf redis-#{version_number}.tar.gz"
  cwd "/tmp"
  action :nothing
  notifies :run, "execute[build_and_install_redis]", :immediately
end

# Configure the application: install
# sudo make install
execute "build_and_install_redis" do
  command 'make && make install'
  cwd "/tmp/redis-#{version_number}"
  action :nothing
  notifies :run, "execute[install_server_redis]", :immediately
end

# cd utils
# sudo ./install_server.sh
execute "install_server_redis" do
  command "echo -n | ./install_server.sh"
  cwd "/tmp/redis-#{version_number}/utils"
  action :nothing
end

# sudo service redis_6379 start
service "redis_6379" do
  action [ :enable, :start ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true, :restart => true
end