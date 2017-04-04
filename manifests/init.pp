class zk_web (
  $package_source_base = 'https://github.com/qiuxiafei/zk-web/archive',
  $version             = '1.0',
  $user                = 'zk-web',
  $server_port         = '8080',
  $install_dir         = '/opt',
  $java_install        = false,
  $java_package        = undef,
  $service_ensure      = 'running',
  $service_enable      = true
){
  anchor {'zk_web::begin': }

  file { $install_dir:
    ensure => directory
  }
  file { "${install_dir}/zk-web-${version}":
    ensure  => directory,
    owner   => $user,
    group   => $user,
    require => User[$user]
  }
  group { $user:
    ensure => present
  }
  user { $user:
    ensure     => present,
    groups     => $user,
    managehome => true,
    shell      => '/sbin/nologin'
  }

  class { '::leiningen': }

  if $java_install == true {
    # Install java
    class { '::java':
      package      => $java_package,
      distribution => 'jre',
    }

    # ensure we first install java, the package and then the rest
    Anchor['zk_web::begin'] ->
    Class['::java'] ->
    Class['zk_web::package']
  }
  class { 'zk_web::package':
    require      => [ File[$install_dir], User[$user] ]
  } ->
  class { 'zk_web::config':
  } ->
  class { 'zk_web::service':
    service_ensure => $service_ensure,
    service_enable => $service_enable
  }
}
