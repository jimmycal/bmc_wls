default['domain-mt']['name'] = "MTDomain"
default['domain-mt']['domains_path'] = "/data/domains"
default['domain-mt']['apps_path'] = "/data/apps"


default['domain-mt']['machines'] = [
	#{
	#	"name" => "LocalMachine",
	#	"nm_address" => "localhost",
	#	"nm_port" => "5556"
	#}
]

default['domain-mt']['clusters'] = [
]

default['domain-mt']['admin_server'] = {
	"base_name" => "AdminServer",
	"new_name" => "admin_server",
	"machine_name" => "AdminMachine",
  "username" => "weblogic",
  "password" => "welcome1",
	"port" => "7001",
  "sslport" => "7002"
}

default['domain-mt']['managed_servers'] = [
	#{
	#	"base_name" => "AdminServer",
	#	"new_name" => "AdminServer",
	#	"address" => "localhost",
	#	"port" => "7001"
	#	"machine" => "LocalMachine"
	#}
]
