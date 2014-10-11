node default {
  class { 'authbind':
    package_ensure => installed,
  }
}
