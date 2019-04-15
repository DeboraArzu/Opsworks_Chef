#
# Cookbook:: Redis
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'Redis::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'update the package repository' do
      expect(chef_run).to run_execute('apt-get update')
    end

    it 'installs the necessary packages' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'retrieves the application from source' do
      expect(chef_run).to create_remote_file("/tmp/redis-stable.tar.gz")
    end

    it 'unzips the application' do
      expect(chef_run).to nothing_execute('unzip_redis_archive')
    end

    it 'build it and installs the application' do
      expect(chef_run).to nothing_execute('redis_build_and_install')
    end

    it 'installs redis server' do
      expect(chef_run).to nothing_execute('echo -n | ./install_server.sh')
    end

    it 'start the service' do
      expect(chef_run).to start_service('redis_6379')
    end
    
  end
end