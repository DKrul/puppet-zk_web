class zk_web::package {
  include wget

  package { 'gzip':
    ensure => present,
  }

  Archive {
    provider => 'wget',
    require  => Package['wget', 'gzip'],
  }

  archive { "${zk_web::install_dir}/v${zk_web::version}.tar.gz":
    ensure          => present,
    extract         => true,
    extract_command => 'tar xfz %s',
    extract_path    => $zk_web::install_dir,
    source          => "${zk_web::package_source_base}/v${zk_web::version}.tar.gz",
    creates         => "${zk_web::install_dir}/zk-web-${zk_web::version}/resources",
    cleanup         => true,
    user            => $zk_web::user,
    group           => $zk_web::user,
    require         => [
      Group[$zk_web::user],
      User[$zk_web::user],
      File[$zk_web::install_dir]
    ]
  }
  file { '/opt/zk-web':
    ensure  => link,
    owner   => $zk_web::user,
    group   => $zk_web::user,
    target  => "${zk_web::install_dir}/zk-web-${zk_web::version}",
    require => Archive["${zk_web::install_dir}/v${zk_web::version}.tar.gz"]
  }
}
