# == Class: authbind
#
# Manages the authbind package and service.
#
# === Parameters
#
# [*build_authbind*]
#   Boolean defining if authbind should be build from source.  This is
#   becomes an option on Debian based systems. Otherwise, this must be
#   true otherwise the install will fail.
#
# [*version*]
#   The authbind project version to install.  Valid values are the releases
#   (i.e. 2.1.1 and 1.2.0) or latest (which will be the latest release).
#
# [*build_dir*]
#   Directory to keep all the build artifacts when building the project from
#   source.  Defaults to '/opt/'.
#
# [*conf_dir*]
#   Directory to keep all the authbind rules (port, uid, and user).  Defaults
#   to '/etc/authbind/'.  This only has an effect if building from source.
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
  $build_authbind = $::authbind::params::build_authbind,
  $version        = $::authbind::params::authbind_version,
  $build_dir      = $::authbind::params::authbind_build_dir,
  $conf_dir       = $::authbind::params::conf_dir,
) inherits authbind::params {
  validate_bool($build_authbind)
  validate_re($version, ['^latest$', '^1.2.0$', '^2.1.1$'])
  validate_absolute_path($build_dir)
  validate_absolute_path($conf_dir)

  if ( $build_authbind == false ) {
    case $::operatingsystem {
      'Debian', 'Ubuntu': {
        if ( $conf_dir != $::authbind::params::conf_dir ) {
          notify { 'Explain conf_dir not set':
            message => "The ${::operatingsystem} authbind package only allows a configuration directory at '${::authbind::params::conf_dir}'.",
          }
        }

        package { 'authbind':
          ensure => $version,
        }
      }
      default: {
        fail("Authbind does not have a package release on ${::operatingsystem}.")
      }
    }

    anchor { 'authbind::installed':
      require => Package['authbind'],
    }
  } else {
    # Install necessary packages for build.
    case $::operatingsystem {
      'Debian', 'Ubuntu': {
        ensure_packages(
          'build-essential',
          {'before' => Anchor['authbind::prepare_build']}
        )
      }
      'Fedora', 'RedHat', 'CentOS', 'OEL', 'OracleLinux', 'Amazon', 'Scientific': {
        ensure_packages(
          ['make', 'gcc', 'glibc-devel'],
          {'before' => Anchor['authbind::prepare_build']}
        )
      }
      default: {
        fail("${module_name} is not supported on ${::operatingsystem}.")
      }
    }

    Exec {
      path => $::path,
    }

    exec { "Make dir ${build_dir}":
      command => "mkdir -p ${build_dir}",
      creates => $build_dir,
      cwd     => '/',
      before  => File[$build_dir]
    }

    file { $build_dir:
      ensure => directory,
    }

    $base_url = 'http://ftp.de.debian.org/debian/pool/main/a/authbind'
    if $version == $::authbind::params::authbind_version {
      $authbind_download_url = "${base_url}/authbind_2.1.1.tar.gz"
      $unpacked_dir          = 'authbind-2.1.1'
    } else {
      $authbind_download_url = "${base_url}/authbind_${version}.tar.gz"
      $unpacked_dir          = "authbind-${version}"
    }

    exec { "Download and untar authbind ${version}":
      command => "wget -O - ${authbind_download_url} | tar xz",
      creates => "${build_dir}/${unpacked_dir}",
      cwd     => $build_dir,
      require => File[$build_dir],
      before  => Anchor['authbind::prepare_build'],
    }

    anchor { 'authbind::prepare_build':
      before => Exec['authbind::compile'],
    }

    # If this fails, then a 'make clean' can help
    exec { 'authbind::compile':
      command => "make etc_dir='${conf_dir}'",
      creates => "${build_dir}/${unpacked_dir}/authbind",
      cwd     => "${build_dir}/${unpacked_dir}/",
    }

    file { "${build_dir}/${unpacked_dir}/authbind":
      ensure  => file,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      require => Exec['authbind::compile']
    }

    anchor { 'authbind::install':
      require => File["${build_dir}/${unpacked_dir}/authbind"],
    }

    exec { 'authbind::install':
      command => "make install etc_dir='${conf_dir}'",
      creates => '/usr/local/bin/authbind',
      cwd     => "${build_dir}/${unpacked_dir}/",
      require => Anchor['authbind::install'],
    }

    exec { 'authbind::install_man':
      command => "make install_man etc_dir='${conf_dir}'",
      creates => '/usr/local/share/man/man1/authbind.1',
      cwd     => "${build_dir}/${unpacked_dir}/",
      require => Anchor['authbind::install'],
    }

    anchor { 'authbind::installed':
      require => Exec['authbind::install', 'authbind::install_man'],
    }
  }
}
