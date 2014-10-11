# == Class: authbind
#
# Setup the authbind package.
#
# === Parameters
#
# [*package_ensure*]
#   Define the state of the authbind package.
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
  $package_ensure = $autbind::params::package_ensure,
) {
  validate_string($package_ensure)

  package { $authbind::params::package_name:
    ensure => $package_ensure,
  }
}
