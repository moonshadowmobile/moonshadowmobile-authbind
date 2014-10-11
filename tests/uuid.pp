node default {
  include ::authbind

  user { 'bob':
    ensure => present,
    uid    => 34,
  }

  # Basic uuid port binding.
  authbind::uuid { '34':
    ports   => {
      453 => '0.0.0.0',
      78  => '192.168.0.0/16',
    },
    require => User['bob']
  }
}
