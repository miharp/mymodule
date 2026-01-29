# @summary Configures mymodule.
#
# @api private
#
class mymodule::config {
  assert_private()

  file { $mymodule::config_file_path:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mymodule/mymodule.conf.erb'),
  }
}
