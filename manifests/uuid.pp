# == Type: authbind::uuid
#
# Configure access for a user UUID to a privileged port with a certain IP range
#
# === Parameters
#
# [*uuid*]
#   User authbind will allow access for. Defaults to the title.
#
# [*ports*]
#   Hash of all the ports and address ranges permission is to be given to.
#
# === Examples
#
#  authbind::uuid { '33':
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
define authbind::uuid (
  $ports,
  $uuid = $title,
) {
  file { "${::authbind::parmas::uuid_dir}/${uuid}":
    ensure  => file,
    owner   => $uuid,
    group   => $uuid,
    mode    => '0750',
    content => template("${module_name}/uuid.erb"),
    require => [
      Package[$::authbind::params::package_name],
    ],
  }
}
