# == Type: authbind::addr
#
# Configure a privileged port to be accessable to a user or group for a given
# address range.
#
# This will create an appropriate file that is executable by the
# correct user and/or group within the authbind structure.
#
# === Parameters
#
# [*user*]
#   User name which authbind will allow access for.
#
# [*group*]
#   Optional group name which authbind will allow access for if provided.
#
# [*port*]
#   Local TCP or UDP port or port range authbind will allow access to.
#
# [*addr*]
#   Valid IPV4 or IPV6 address or address range authbind will allow
#   access to. Defaults to the title.
#
# === Examples
#
#  Allow bob or anyone in the users group to run an application that
#  listens for connections on the local private network at ports 80
#  through 90.
#
#  authbind::addr { '192.168.0.0/24':
#    user  => 'bob',
#    group => 'users',
#    port  => '80-90'
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
define authbind::addr (
  $port,
  $user,
  $group = '',
  $addr  = $title
) {
  File {
    ensure => file,
    owner  => $user,
  }

  if $group == '' {
    file { "${::authbind::parmas::addr_dir}/${addr},${port}":
      mode    => '0700',
      require => [
        User[$user],
        Package[$::authbind::params::package_name],
      ],
    }
  } else {
    file { "${::authbind::parmas::addr_dir}/${addr},${port}":
      group   => $group,
      mode    => '0770',
      require => [
        User[$user],
        Group[$group],
        Package[$::authbind::params::package_name],
      ],
    }
  }
}
