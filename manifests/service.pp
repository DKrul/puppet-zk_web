class zk_web::service (
  $service_ensure = $zk_web::service_ensure,
  $service_enable = $zk_web::service_enable,
  $user           = $zk_web::user
){
  $install_path = "${zk_web::install_dir}/zk-web"

  if ($service_ensure != 'running') and ($service_enable == false) {
    $file_ensure = 'absent'
  } else {
    $file_ensure = 'present'
  }
  file { '/usr/lib/systemd/system/zk-web.service':
    ensure  => $file_ensure,
    content => template('zk_web/zk-web.service.erb'),
  }
  exec { "systemd_reload_${title}":
    command     => '/usr/bin/systemctl daemon-reload',
    subscribe   => File['/usr/lib/systemd/system/zk-web.service'],
    refreshonly => true,
  }
  service { 'zk-web':
    ensure => $service_ensure,
    enable => $service_enable,
    require => [
      Class['leiningen'],
      File['/usr/lib/systemd/system/zk-web.service']
    ]
  }
}
