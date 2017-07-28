#
# Cookbook Name:: wls
# Recipe:: install-12c
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe "bmcwls::prepare-environment"

os_user = node['env-122']['os_user']
os_group = node['env-122']['os_installer_group']

directory '/software' do
  owner os_user
  group os_group
  mode '0755'
  action :create
end
# Getting the installer
installer_jar = File.join(node['env-122']['installer_path'], node['wls-122']['installer_file'])

remote_file installer_jar do
	source {node['env-122']['wls_installer_url']}
	action :create_if_missing
	only_if { node['env-122']['remote_install'] }
end

# Define Response File
response_file = File.join(Chef::Config[:file_cache_path], "install_wls-122.rsp")
mw_home = node['env-122']['home']

template response_file do
  source "install_wls-122.rsp.erb"
  variables({
    :mw_home 	=> mw_home
    })
end

# Run Installer
install_command = "java -jar #{installer_jar} -silent -responseFile  #{response_file} -invPtrLoc #{node['env-122']['orainventory_file']}"

execute install_command do
	cwd node['env-122']['installer_path']
  action :run
  user os_user
  group os_group
	creates "#{node['env-122']['home']}/oraInst.loc"
end
