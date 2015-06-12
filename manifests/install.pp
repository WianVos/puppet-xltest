# == Class xltest::install
#
class xltest::install {

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { $xltest::params::package_name:
    ensure => present,
  }
}
