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
  Authbind::Port {
    require => User['bob']
  }

  # Basic port binding.
  authbind::port { '80':
    user => 'bob',
  }

  # Slightly more complex port binding.
  authbind::port { 'Allow hilarious https connections':
    user  => 'bob',
    port  => 444,
    group => 'users',
  }
}
