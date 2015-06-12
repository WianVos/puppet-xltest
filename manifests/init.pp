# == Class: xltestview
#
# Full description of class xltestview here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class xltestview (
  $os_user                      = $xlrelease::params::os_user,
  $os_group                     = $xlrelease::params::os_group,
  $tmp_dir                      = $xlrelease::params::tmp_dir,
  $xlt_version                  = $xlrelease::params::xlt_version,
  $xlt_basedir                  = $xlrelease::params::xlt_basedir,
  $xlt_serverhome               = $xlrelease::params::xlt_serverhome,
  $xlt_licsource                = $xlrelease::params::xlt_licsource,
  $xlt_repopath                 = $xlrelease::params::xlt_repopath,
  $xlt_initrepo                 = $xlrelease::params::xlt_initrepo,
  $xlt_http_port                = $xlrelease::params::xlt_http_port,
  $xlt_http_bind_address        = $xlrelease::params::xlt_http_bind_address,
  $xlt_http_context_root        = $xlrelease::params::xlt_http_context_root,
  $xlt_importable_packages_path = $xlrelease::params::xlt_importable_packages_path,
  $xlt_ssl                      = $xlrelease::params::xlt_ssl,
  $xlt_download_user            = $xlrelease::params::xlt_download_user,
  $xlt_download_password        = $xlrelease::params::xlt_download_password,
  $xlt_download_proxy_url       = $xlrelease::params::xlt_download_proxy_url,
  $xlt_rest_user                = $xlrelease::params::xlt_rest_user,
  $xlt_rest_password            = $xlrelease::params::xlt_rest_password,
  $xlt_admin_password           = $xlrelease::params::xlt_admin_password,
  $java_home                    = $xlrelease::params::java_home,
  $install_java                 = $xlrelease::params::install_java,
  $install_type                 = $xlrelease::params::install_type,
  $puppetfiles_xlrelease_source = $xlrelease::params::puppetfiles_xlrelease_source,
  $custom_download_server_url   = undef,
) inherits xltestview::params {

  # validate parameters here

  # compose some variables based on the input to the class
  if ( $custom_download_server_url == undef ) {
    $xlt_download_server_url = "https://dist.xebialabs.com/customer/xl-testview/server/${xlr_version}/xl-testview-server-${xlt_version}.zip"
  } else {
    $xlt_download_server_url = $custom_download_server_url
  }


  if str2bool($::xlt_ssl) {
    $rest_protocol = 'https://'
    # Check certificate validation
  } else {
    $rest_protocol = 'http://'
  }

  if ($xlt_http_context_root == '/') {
    $rest_url = "${rest_protocol}${xlt_rest_user}:${xlt_rest_password}@${xlt_http_bind_address}:${xlt_http_port}"
  } else {
    if $xlt_http_context_root =~ /^\// {
      $rest_url = "${rest_protocol}${xlt_rest_user}:${xlt_rest_password}@${xlt_http_bind_address}:${xlt_http_port}${xlt_http_context_root}"
    } else {
      $rest_url = "${rest_protocol}${xlt_rest_user}:${xlt_rest_password}@${xlt_http_bind_address}:${xlt_http_port}/${xlt_http_context_root}"
    }
  }

  # flow control

  anchor { 'xltestview::begin': } ->
  class  { '::xltestview::install': } ->
  class  { '::xltestview::config': } ~>
  class  { '::xltestview::service': } ->
  anchor { 'xltestview::end': }
}
