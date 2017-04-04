class zk_web::config (
  $server_port = $zk_web::server_port,
  $users       = undef
){
  if $users != undef {
    assert_type(Hash, $users) | $expected, $actual | { fail "Parameter ${title}::users should be '${expected}', not '${actual}'." }
    $real_users = $users
  } else {
    $real_users = { 'admin' => 'hello' }
  }
  file { "${zk_web::install_dir}/zk-web/.zk-web-conf.clj":
    ensure  => present,
    owner   => $zk_web::user,
    group   => $zk_web::user,
    content => template('zk_web/zk-web-conf.clj.erb'),
    notify  => Service['zk-web']
  }
}
