# BMC WLS Configuration

This cookbook is configures and installs WebLogic 12.2.1.1 on a BMC Server

**Getting Started**
berks install  #Installs all dependant libraries
check your ~./berks folder for definitions

**Local Testing w/ Vagrant**
Note this requires you have Virtual Box and Vagrant installed on your machine.

Review the .kitchen.yml to update a mapped directory for locating the installation binaries

Run - 
kitchen list       #Display list of server and chef configurations
kitchen converge <config-name> 

**Example command to configure a BM Server running OEL 7x**

    knife bootstrap 129.146.4.106 -N wls-demo1 -x opc  -r 'recipe[bmcwls::install-wls122],recipe[bmcwls::create_mt_nm-domain71]' -j '{"domain-mt":{"name":"BareMetal","admin_server":{"port":"7001","sslport":"7002"}}}' --sudo
