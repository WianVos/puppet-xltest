# == Class xltest::params
#
# This class is meant to be called from xltest
# It sets variables according to platform
#
class xltest::params {
  case $::osfamily {
    'RedHat': {
      $package_name = 'xltest'
      $service_name = 'xltest'
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
