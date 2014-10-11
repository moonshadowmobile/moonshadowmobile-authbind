# == Class: authbind
#
# Setup the authbind package.
#
# === Parameters
#
# [*package_ensure*]
#   Define the state of the authbind package.
#
# [*package_name*]
#   The name of the authbind packaged to install.
#
# === Examples
#
# To start:
#
#  include authbind
#
# to remove authbind:
#
#  class { 'authbind':
#    package_ensure => absent
#  }
#
# === Authors
#
# Tyler Yahn <tyler@moonshadowmobile.com>
#
# === Copyright
#
# Copyright 2014 Moonshadow Mobile Inc.
#
class authbind (
  $package_ensure = $::authbind::params::package_ensure,
  $package_name   = $::authbind::params::package_name,
) inherits authbind::params {
  validate_string($package_ensure)

  package { $package_name:
    ensure => $package_ensure,
  }
}
