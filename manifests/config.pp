# == Class xltestview::config
#
# This class is called from xltestview
#
class xltestview::config {

   # get parameters
  $xlt_version                  = $xlretestvie::xlt_version
  $xlt_basedir                  = $xltestview::xlt_basedir
  $xlt_serverhome               = $xltestview::xlt_serverhome
  $xlt_licsource                = $xltestview::xlt_licsource
  $xlt_repopath                 = $xltestview::xlt_repopath
  $xlt_initrepo                 = $xltestview::xlt_initrepo
  $xlt_http_port                = $xltestview::xlt_http_port
  $xlt_http_bind_address        = $xltestview::xlt_http_bind_address
  $xlt_http_context_root        = $xltestview::xlt_http_context_root
  $xlt_importable_packages_path = $xltestview::xlt_importable_packages_path
  $xlt_ssl                      = $xltestview::xlt_ssl
  $xlt_admin_password           = $xltestview::xlt_admin_password
  $install_type                 = $xltestview::install_type
  $install_java                 = $xltestview::install_java
  $java_home                    = $xltestview::java_home
  $os_user                      = $xltestview::os_user
  $os_group                     = $xltestview::os_group
  $tmp_dir                      = $xltestview::tmp_dir
  $puppetfiles_xltestview_source = $xltestview::puppetfiles_xltestview_source

  # Make this a private class
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }


  #flow controll
  anchor{'xlt config_start':}
  #-> File['xltestview default properties']
  -> Ini_setting['xltestview.admin.password','xltestview.http.port','xltestview.jcr.repository.path','xltestview.jcr.repository.path',
                  'xltestview.ssl','xltestview.http.bind.address','xltestview.http.context.root','xltestview.importable.packages.path']
  -> Exec ['init xl-testview']
  -> anchor{'xlt config_end':}

  # resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present,
    mode   => '0640',
    ignore => '.gitkeep'
  }

  Ini_setting {
    path    => "${xlt_serverhome}/conf/xl-testview-server.conf",
    ensure  => present,
    section => '',
  }

  # actual resources
  file{"${xlt_serverhome}/conf/xl-testview-server.conf":}

  # configuration settings
  #file { 'xltestview default properties':
  #  ensure => present,
  #  path   => "${xlt_serverhome}/conf/deployit-defaults.properties",
  #}

  if $::xltestview_encrypted_password == undef {
    ini_setting {
      'xltestview.admin.password':
      setting => 'admin.password',
      value   => $xlt_admin_password
    }
  } else {
    ini_setting {
      'xltestview.admin.password':
      setting => 'admin.password',
      value   => $::xltestview_encrypted_password
    }
  }

  ini_setting {
    'xltestview.http.port':
    setting => 'http.port',
    value   => $xlt_http_port;

    'xltestview.jcr.repository.path':
    setting => 'jcr.repository.path',
    value   => regsubst($xlt_repopath, '^/', 'file:///');

    'xltestview.ssl':
    setting => 'ssl',
    value   => $xlt_ssl;

    'xltestview.http.bind.address':
    setting => 'http.bind.address',
    value   => $xlt_http_bind_address;

    'xltestview.http.context.root':
    setting => 'http.context.root',
    value   => $xlt_http_context_root;

    'xltestview.importable.packages.path':
    setting => 'importable.packages.path',
    value   => $xlt_importable_packages_path;
  }


  if str2bool($xlt_initrepo) {
      exec { 'init xl-testview':
        creates     => "${xlt_serverhome}/${xlt_repopath}",
        command     => "${xlt_serverhome}/bin/server.sh -setup -reinitialize -force -setup-defaults ${xlt_serverhome}/conf/xl-testview-server.conf",
        user        => $os_user,
        environment => ["JAVA_HOME=${java_home}"]
      }
  } else {
      exec { 'init xl-testview':
        creates     => "${xlt_serverhome}/${xlt_repopath}",
        command     => "${xlt_serverhome}/bin/server.sh -setup -force -setup-defaults ${xlt_serverhome}/conf/xl-testview-server.conf",
        user        => $os_user,
        environment => ["JAVA_HOME=${java_home}"]
      }
  }

}
