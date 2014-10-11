# == Type: authbind::port
#
# Configure a privileged port to be accessable to a user or group.
#
# This will create an appropriate file that is executable by the
# correct user and/or group within the authbind structure.
#
# === Parameters
#
# [*user*]
#   Required user name which authbind will allow access for.
#
# [*group*]
#   Optional group name which authbind will allow access for if provided.
#
# [*port*]
#   Valid TCP or UDP port authbind will allow access to. Defaults to the title.
#
# === Examples
#
#  Allow the user bob or anyone in the group users to run an application
#  that listens on port 443.
#
#  authbind::port { '443':
#    user  => 'bob',
#    group => 'users',
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
define authbind::port (
  $user,
  $group = '',
  $port  = $title
) {
  File {
    ensure => file,
    owner  => $user,
  }

  if $group == '' {
    file { "${::authbind::parmas::port_dir}/${port}":
      mode    => '0700',
      require => [
        User[$user],
        Package[$authbind::params::package_name],
      ],
    }
  } else {
    file { "${::authbind::parmas::port_dir}/${port}":
      group   => $group,
      mode    => '0770',
      require => [
        User[$user],
        Group[$group],
        Package[$authbind::params::package_name],
      ],
    }
  }
}
