default['env-122']['os_user'] = "oracle"
default['env-122']['os_installer_group'] = "oinstall"
default['env-122']['os_timezone'] = "America/Lima"
default['env-122']['os_user_home'] = "/home/#{node['env-122']['os_user']}"
default['env-122']['orainventory_directory'] = "#{node['env-122']['os_user_home']}/oraInventory"
default['env-122']['orainventory_file'] = "#{node['env-122']['orainventory_directory']}/ora_inventory.rsp"
default['env-122']['version'] = "1221"
default['env-122']['home'] = "/data/wls/#{node['env-122']['version']}"

default['env-122']['soft_nofile'] = "8182"
default['env-122']['hard_nofile'] = "8182"

default['env-122']['packages'] = [
	{ "name" => "binutils", "arch" => "x86_64" },
	{ "name" => "compat-libcap1", "arch" => "x86_64" },
	{ "name" => "gcc", "arch" => "x86_64" },
	{ "name" => "gcc-c++", "arch" => "x86_64" },
	{ "name" => "glibc", "arch" => "x86_64" },
	{ "name" => "glibc-devel", "arch" => "x86_64" },
	{ "name" => "ksh", "arch" => "x86_64" },
	{ "name" => "libgcc", "arch" => "x86_64" },
	{ "name" => "compat-libstdc++-33", "arch" => "x86_64" },
	{ "name" => "libstdc++", "arch" => "x86_64" },
	{ "name" => "libstdc++-devel", "arch" => "x86_64" },
	{ "name" => "libaio", "arch" => "x86_64" },
	{ "name" => "elfutils-libelf-devel", "arch" => "x86_64" },
	{ "name" => "libaio-devel", "arch" => "x86_64" },
	{ "name" => "libaio", "arch" => "x86_64" },
	{ "name" => "libaio-devel", "arch" => "x86_64" },
	{ "name" => "make", "arch" => "x86_64" },
	{ "name" => "sysstat", "arch" => "x86_64" }
]

default['env-122']['installer_path'] = "/opt/installers"

override['java']['install_flavor'] = "oracle"
override['java']['jdk_version'] = "8"
override['java']['oracle']['accept_oracle_download_terms'] = true

override['firewall']['allow_ssh'] = true
