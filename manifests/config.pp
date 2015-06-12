# == Class xltest::config
#
# This class is called from xltest
#
class xltest::config {

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
