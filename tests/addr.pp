node default {
  include ::authbind

  group { 'users':
    ensure => present,
  }

  user { 'bob':
    ensure  => present,
    gid     => 'users',
    require => Group['users'],
  }

  # Ensure Bob is there
  Authbind::Addr {
    require => User['bob']
  }

  # Basic addr request
  authbind::addr { '192.168.0.10':
    user => 'bob',
    port => 80,
  }

  # Slightly more complex addr binding.
  authbind::addr { 'Connect to Sharon':
    user  => 'bob',
    port  => 80,
    group => 'users',
    addr  => '192.168.0.191',
  }
}
