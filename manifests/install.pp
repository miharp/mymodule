# @summary Installs the mymodule package.
#
# @api private
#
class mymodule::install {
  assert_private()

  package { $mymodule::package_name:
    ensure => $mymodule::package_ensure,
  }
}
