os_user = node['env-122']['os_user']
os_installer_group = node['env-122']['os_installer_group']

# Prepare Template
create_mt_domain_py = File.join(Chef::Config[:file_cache_path], "create_mt-domain.py")
mw_home = node['env-122']['home']
wl_home = "#{mw_home}/wlserver"
common_home = "#{mw_home}/oracle_common"
java_home = node['java']['java_home']

template create_mt_domain_py do
	source "create_mt-domain.py.erb"
	variables({
		:domains_path => node['domain-mt']['domains_path'],
		:domain_name => node['domain-mt']['name'],
		:admin_server => node['domain-mt']['admin_server'],
    :server_ip => node['ipaddress'],
		:wl_home => wl_home,
		:common_home => common_home,
	})
end

# Create directories
domain_home = "#{node['domain-mt']['domains_path']}/#{node['domain-mt']['name']}"

directory node['domain-mt']['domains_path'] do
	owner os_user
	group os_installer_group
	recursive true
	action :create
end

directory node['domain-mt']['apps_path'] do
	owner os_user
	group os_installer_group
	recursive true
	action :create
end

# Run WLST script
wlst_exec = "#{mw_home}/oracle_common/common/bin/wlst.sh #{create_mt_domain_py}"

ENV['ORACLE_HOME'] = mw_home
ENV['TZ'] = node['env-122']['os_timezone']

execute wlst_exec do
	user os_user
	group os_installer_group
	action :run
	creates "#{domain_home}/config/config.xml"
end

# Node Manager Properties file
nm_props = "#{domain_home}/nodemanager/nodemanager.properties"

template nm_props do
	source "node_manager-12c.properties.erb"
	variables({
		:domain_home => domain_home,
		:java_home => java_home,
  	:server_ip => node['ipaddress']
	})
end

systemd_service 'wls_nm' do
  description 'Weblogic Node Manager'
  after %w( network.target )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    environment 'LANG' => 'C'
    exec_start "#{domain_home}/bin/startNodeManager.sh"
    kill_signal 'SIGWINCH'
    kill_mode 'mixed'
    private_tmp true
		user 'oracle'
  end
	action [:create, :enable, :start]
	only_if { systemd? }
end

systemd_service 'wls_admin' do
  description 'Weblogic Admin Server'
  after %w( network.target )
  install do
    wanted_by 'multi-user.target'
  end
  service do
    environment 'LANG' => 'C'
    exec_start "#{domain_home}/bin/startWebLogic.sh"
    kill_signal 'SIGWINCH'
    kill_mode 'mixed'
    private_tmp true
    user 'oracle'
  end
  action [:create, :enable, :start]
  only_if { systemd? }
end

template '/etc/init/wls_nm.conf' do
	source "start-node_manager-12c.sh.erb"
	variables({
		:os_user => os_user,
		:domain_home => domain_home
	})
  only_if { upstart? }
end

execute 'Start NodeManager' do
	command 'start wls_nm'
	only_if { upstart? }
end

template '/etc/init/wls_admin.conf' do
	source "start-admin_server-12c.sh.erb"
	variables({
		:os_user => os_user,
		:domain_home => domain_home
	})
  only_if { upstart? }
end

# noinspection CookbookSourceRoot
execute 'Start Admin Server' do
	command 'start wls_admin'
	only_if { upstart? }
end
