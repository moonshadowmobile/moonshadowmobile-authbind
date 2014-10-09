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
#  class { 'authbind': }
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
) inherits authbind::params {
  validate_string($package_ensure)

  package { $package_name:
    ensure => $package_ensure,
  }
}
