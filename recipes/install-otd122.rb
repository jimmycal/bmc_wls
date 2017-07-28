#
# Cookbook Name:: wls
# Recipe:: install-12c
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe "bmcwls::install-wls122"

os_user = node['env-122']['os_user']
os_group = node['env-122']['os_installer_group']

# Getting the installer
installer_bin = File.join(node['env-122']['installer_path'], node['otd-122']['installer_file'])

remote_file installer_bin do
	source "#{node['cloud']['storage_url']}/#{node['otd-122']['installer_file']}"
	headers ({"AUTHORIZATION" => "Basic #{Base64.encode64("#{node['cloud']['cloud_username']}:#{node['cloud']['cloud_password']}")}"})
	mode '777'
	action :create_if_missing
	only_if { node['env-122']['remote_install'] }
end


# Run Installer
install_command = "#{installer_bin} -ignoreSysPrereqs -silent ORACLE_HOME=#{node['env-122']['home']} DECLINE_SECURITY_UPDATES=true INSTALL_TYPE='Collocated OTD (Managed through WebLogic server)' -invPtrLoc #{node['env-122']['orainventory_file']}"
execute install_command do
	cwd node['env-122']['installer_path']
  action :run
  user os_user
  group os_group
	creates "#{node['env-122']['home']}/otdInst.loc"
end
