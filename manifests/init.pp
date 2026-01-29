# @summary Main class for the mymodule module.
#
# @param package_ensure
#   Whether to install the package. Defaults to 'present'.
# @param package_name
#   The name of the package to manage.
# @param config_file_path
#   The path to the configuration file.
# @param service_ensure
#   Whether the service should be running. Defaults to 'running'.
# @param service_enable
#   Whether the service should be enabled at boot. Defaults to true.
# @param service_name
#   The name of the service to manage.
#
class mymodule (
  String $package_ensure    = 'present',
  String $package_name      = 'mymodule',
  String $config_file_path  = '/etc/mymodule/mymodule.conf',
  String $service_ensure    = 'running',
  Boolean $service_enable   = true,
  String $service_name      = 'mymodule',
) {
  contain mymodule::install
  contain mymodule::config
  contain mymodule::service

  Class['mymodule::install']
  -> Class['mymodule::config']
  ~> Class['mymodule::service']
}
