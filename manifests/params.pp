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
  $authbind_version   = 'stable'
  $authbind_build_dir = '/opt'
  $conf_dir           = '/etc/authbind'

  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $build_authbind = false
    }
    'Fedora', 'RedHat', 'CentOS', 'OEL', 'OracleLinux', 'Amazon', 'Scientific': {
      $build_authbind = true
    }
    default: {
      fail("${module_name} is not supported on ${::operatingsystem}.")
    }
  }
}
