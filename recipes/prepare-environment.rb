
#
# Cookbook Name:: wls
# Recipe:: prepare-environment-12c
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe "java"
include_recipe 'chef-sugar::default'

update_yum = "yum upgrade -y"

execute update_yum do
	action :run
end

# User and group creation
os_user = node['env-122']['os_user']
os_installer_group = node['env-122']['os_installer_group']

group os_installer_group do
	action :create
	append true
end


user os_user do
	manage_home true
  comment "Oracle user"
	gid os_installer_group
	home node['env-122']['os_user_home']
	shell "/bin/bash"
	password "$1$rUhN5PYi$2rQAEEuOBScZOKsMRpHDe0"
end

# Increase user limits
soft_limits = "#{os_user}	soft    nofile    #{node['env-122']['soft_nofile']}"
hard_limits = "#{os_user}	hard    nofile    #{node['env-122']['hard_nofile']}"
limits_file = "/etc/security/limits.conf"

bash "increase_limits" do
	user 'root'

	code <<-END.gsub(/^    /, '')
    echo soft_limits  >> limits_file
    echo hard_limits >> limits_file
	END

	not_if do
		file = ::File.read(limits_file)
		file.include?(soft_limits) \
    && \
    file.include?(hard_limits)
	end
end

reset_command = "ulimit -a"
run_reset = "su -l #{os_user} -c '#{reset_command}'"

execute run_reset do
	action :run
end

# Install packages
node['env-122']['packages'].each do |package|
	package_title = "#{package['name']}.#{package['arch']}"
	yum_package package_title do
		action :install
	end
end

# Create FMW Directories
directory node['env-122']['home'] do
	owner os_user
	group os_installer_group
	recursive true
	action :create
end

# Create OraInventory template
ora_inventory_directory = node['env-122']['orainventory_directory']
ora_inventory_file = node['env-122']['orainventory_file']

directory ora_inventory_directory do
	owner os_user
	group os_installer_group
	recursive true
	action :create
end

template ora_inventory_file do
	source "ora_inventory.rsp.erb"
	owner os_user
	group os_installer_group
	variables({
								:ora_inventory_directory => ora_inventory_directory,
								:install_group => os_installer_group
						})
end

firewall 'default' do
	action    :disable
end

#firewall_rule 'allow world to ssh' do
#  port 22
#  source '0.0.0.0/0'
#  only_if { node['firewall']['allow_ssh'] }
#end
# open multiple ports for http/https, note that the protocol
# attribute is required when using ports
#firewall_rule 'http/https' do
#  protocol :tcp
#  port     [80, 443, 8080, 7001, 7002, 5556]
#  command   :allow
# end
