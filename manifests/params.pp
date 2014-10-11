# == Class: authbind::params
#
# Define defaults for os specific resources, and set module level variables.
#
# === Authors
#
# Tyler Yahn <tyler@moonshadowmobile.com>
#
# === Copyright
#
# Copyright 2014 Moonshadow Mobile Inc.
#
class authbind::params {
  $package_ensure = 'present'

  case $::osfamily {
    'Debian': {
      $package_name = 'authbind'
      $base_dir     = '/etc/authbind'
      $port_dir     = "${base_dir}/byport"
      $addr_dir     = "${base_dir}/byaddr"
      $uuid_dir     = "${base_dir}/byuuid"
    }
    default: {
      fail("${module_name} is not supported on a ${::osfamily} based system.")
    }
  }
}
