# == Class xltest::service
#
# This class is meant to be called from xltest
# It ensure the service is running
#
class xltest::service {
  include xltest::params

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { $xltest::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
