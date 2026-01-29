# @summary Manages the mymodule service.
#
# @api private
#
class mymodule::service {
  assert_private()

  service { $mymodule::service_name:
    ensure => $mymodule::service_ensure,
    enable => $mymodule::service_enable,
  }
}
