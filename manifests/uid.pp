# == Type: authbind::uid
#
# Configure access for a user UID to a privileged port with a certain IP range
#
# === Parameters
#
# [*uid*]
#   User authbind will allow access for. Defaults to the title.
#
# [*ports*]
#   Hash of all the ports and address ranges permission is to be given to.
#
# === Examples
#
#  authbind::uid { '33':
#    ports => { 443 => '0.0.0.0',
#               80  => '192.168.0.0/16', }
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
define authbind::uid (
  $ports,
  $uid = $title,
) {
  file { "${::authbind::parmas::uid_dir}/${uid}":
    ensure  => file,
    owner   => $uid,
    group   => $uid,
    mode    => '0750',
    content => template("${module_name}/uid.erb"),
    require => [
      Package[$::authbind::params::package_name],
    ],
  }
}
