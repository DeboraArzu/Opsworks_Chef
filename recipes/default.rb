# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis

# sudo apt update
execute "apt-get update"

# sudo apt-get install build-essential
package "build-essential"

# sudo apt-get install tcl8.5
package "tcl8.5"

# wget http://download.redis.io/releases/redis-stable.tar.gz
remote_file "/tmp/redis-stable.tar.gz" do
  source "http://download.redis.io/releases/redis-stable.tar.gz"
  notifies :run, "execute[unzip_redis_archive]", :immediately
end

#unzip the archive
execute "unzip_redis_archive" do
  command "tar xzf redis-stable.tar.gz"
  cwd "/tmp"
  action :nothing
  notifies :run, "execute[redis_build_and_install]", :immediately
end

# Configure the application: install
execute "redis_build_and_install" do
  cwd "/tmp/redis-stable.tar.gz"
  action :nothing
  notifies :run, "execute[echo -n | ./install_server.sh]", :immediately
end

# Install the Server
execute "echo -n | ./install_server.sh" do
  cwd "/tmp/redis-stable.tar.gz/utils"
  action :nothing
end

service "redis_6379" do
  action [:start]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end

