# == Class xltestview::install
#
class xltestview::install {

  $xlt_version                   = $xltestview::xlt_version
  $xlt_basedir                   = $xltestview::xlt_basedir
  $xlt_serverhome                = $xltestview::xlt_serverhome
  $xlt_licsource                 = $xltestview::xlt_licsource
  $xlt_download_user             = $xltestview::xlt_download_user
  $xlt_download_password         = $xltestview::xlt_download_password
  $xlt_download_proxy_url        = $xltestview::xlt_download_proxy_url
  $xlt_download_server_url       = $xltestview::xlt_download_server_url
  $install_type                  = $xltestview::install_type
  $install_java                  = $xltestview::install_java
  $java_home                     = $xltestview::java_home
  $os_user                       = $xltestview::os_user
  $os_group                      = $xltestview::os_group
  $tmp_dir                       = $xltestview::tmp_dir
  $puppetfiles_xltestview_source = $xltestview::puppetfiles_xltestview_source

  #flow controll
  anchor{'xlt install':}
  -> anchor{'xlt server_install':}
  -> anchor{'xlt server_postinstall':}
  -> File['xlt conf dir link', 'xlt log dir link']
  -> File[$xlt_serverhome]
  -> File['/etc/init.d/xl-release']
  -> anchor{'xlt install_end':}


  #figure out the server install dir
  $server_install_dir   = "${xlt_basedir}/xl-testview-${xlt_version}-server"

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # install java packages if needed
  if str2bool($install_java) {
    case $::osfamily {
      'RedHat' : {
        $java_packages = ['java-1.7.0-openjdk']
        if !defined(Package[$java_packages]){
          package { $java_packages: ensure => present }
        }
      }
      'Debian' : {
        $java_packages = ['openjdk-7-jdk']
        if !defined(Package[$java_packages]){
          package { $java_packages: ensure => present }
        }
        $unzip_packages = ['unzip']
        if !defined(Package[$unzip_packages]){
          package { $unzip_packages: ensure => present }
        }

      }
      default  : {
        fail("${::osfamily}:${::operatingsystem} not supported by this module")
      }
    }
  }

  # user and group

  group { $os_group: ensure => 'present' }

  user { $os_user:
    ensure     => present,
    gid        => $os_group,
    managehome => false,
    home       => $xlt_serverhome
  }

  # base dir

  file { $xlt_basedir:
    ensure => directory,
    owner  => $os_user,
    group  => $os_group,
  }

  #the actual xl-release installation
  # we're only supporting puppetfiles for now
  case $install_type {
    'puppetfiles' : {

      $server_zipfile = "xl-testview-${xlt_version}-server.zip"

      Anchor['xlt server_install']

      -> file { "${tmp_dir}/${server_zipfile}": source => "${puppetfiles_xltestview_source}/${server_zipfile}" }

      -> file { $server_install_dir: ensure => directory, owner => $os_user, group => $os_group }

      -> exec { 'xlt unpack server file':
        command => "/usr/bin/unzip ${tmp_dir}/${server_zipfile};/bin/cp -rp ${tmp_dir}/xl-release-${xlt_version}-server/* ${server_install_dir}",
        creates => "${server_install_dir}/bin",
        cwd     => $tmp_dir,
        user    => $os_user
      }

      -> Anchor['xlt server_postinstall']
    }
    'download'    : {

        Anchor['xlt server_install']

        -> xltestview_netinstall{ $xlt_download_server_url:
          owner          => $os_user,
          group          => $os_group,
          user           => $xlt_download_user,
          password       => $xlt_download_password,
          destinationdir => $xlt_basedir,
          proxy_url      => $xlt_download_proxy_url
        }

        -> Anchor['xlt server_postinstall']
    }
    default       : { fail('unsupported installation type')
    }
  }

  file { 'xlt log dir link':
    ensure => link,
    path   => '/var/log/xl-release',
    target => "${server_install_dir}/log";
  }

  file { 'xlt conf dir link':
    ensure => link,
    path   => '/etc/xl-release',
    target => "${server_install_dir}/conf"
  }

  ## put the init script in place
  ## the template uses the following variables:
  ## @os_user
  ## @server_install_dir
  file { '/etc/init.d/xl-release':
    content => template("xltestview/xl-release-initd-${::osfamily}.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0700'
  }


# setup homedir
  file { $xlt_serverhome:
    ensure => link,
    target => $server_install_dir,
    owner  => $os_user,
    group  => $os_group
  }

  file { "${xlt_serverhome}/scripts":
    ensure => directory,
    owner  => $os_user,
    group  => $os_group
  }


  case $xlt_licsource {
    /^http/ : {
      File[$xlt_serverhome]

      -> xltestview_license_install{ $xlt_licsource:
        owner                => $os_user,
        group                => $os_group,
        user                 => $xlt_download_user,
        password             => $xlt_download_password,
        destinationdirectory => "${xlt_serverhome}/conf"
      }
      -> Anchor['xlt install_end']
    }
    /^puppet/ : {
      File[$xlt_serverhome]

      -> file{"${xlt_serverhome}/conf/xl-release-license.lic":
        owner  => $os_user,
        group  => $os_group,
        source => $xlt_licsource,
      }
      -> Anchor['xlt install_end']
    }
    undef   : {}
    default : { fail('xlt_licsource input unsupported')}
  }

}
