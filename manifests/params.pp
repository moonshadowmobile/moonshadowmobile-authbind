class authbind::params {
  $package_ensure = 'present',

  case $::osfamily {
    'Debian': {
      $package_name = 'authbind'
      $base_dir     = '/etc/authbind'
      $port_dir     = "${base_dir}/byport"
      $addr_dir     = "${base_dir}/byaddr"
      $uuid_dir     = "${base_dir}/byuuid"
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
