# == Class xltestview::service
#
# This class is meant to be called from xltestview
# It ensure the service is running
#
class xltestview::service {
  include xltestview::params

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { $xltestview::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
