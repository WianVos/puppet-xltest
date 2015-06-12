# == Class xltestview::params
#
# This class is meant to be called from xltestview
# It sets variables according to platform
#
class xltestview::params {
  $xlt_version                  = '1.1.0'
  $xlt_basedir                  = '/opt/xl-testview'
  $xlt_serverhome               = '/opt/xl-testview/xl-testview-server'
  $xlt_licsource                = 'https://dist.xebialabs.com/customer/licenses/download/v2/xl-testview-license.lic'
  $xlt_repopath                 = 'repository'
  $xlt_initrepo                 = true
  $xlt_http_port                = '5516'
  $xlt_http_bind_address        = '0.0.0.0'
  $xlt_http_context_root        = '/'
  $xlt_importable_packages_path = 'importablePackages'
  $xlt_ssl                      = false
  $xlt_download_user            = undef
  $xlt_download_password        = undef
  $xlt_download_proxy_url       = undef
  $xlt_rest_user                = 'admin'
  $xlt_rest_password            = 'xebialabs'
  $xlt_admin_password           = 'xebialabs'

  $os_user        = 'xl-testview'
  $os_group       = 'xl-testview'
  $tmp_dir        = '/var/tmp'
  $install_java   = true
  $install_type   = 'download'
  $puppetfiles_xltestview_source  = undef

  case $::osfamily {
    'RedHat' : {
      $java_home = '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'
    }
    'Debian' : {
      $java_home = '/usr/lib/jvm/java-7-openjdk-amd64'
    }
    default  : { fail("operating system ${::operatingsystem} not supported") }
  }

}
