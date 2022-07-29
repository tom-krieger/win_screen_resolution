# @summary Registry settings
#
# Add necessary registry settings
#
# @param registry_path
#    Registry base key to add all new stuff
# @param is_policy
#    Flag where in the registry to place the values
# @example
#   include win_screen_resolution::registry_gpo_startup_script
class win_screen_resolution::registry_gpo_startup_script (
  String $registry_path,
  Boolean $is_policy,
) {
  registry_key { $registry_path:
    ensure  => present,
    require => File["${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}"]
  }

  registry_key { "${registry_path}\Shutdown":
    ensure  => present,
    require => Registry_key[$registry_path],
  }

  registry::value { 'Set default value for Shutdown':
    key     => "${registry_path}\Shutdown",
    value   => '(default)',
    data    => '',
    require => Registry_key["${registry_path}\Shutdown"],
  }

  registry_key { "${registry_path}\Startup":
    ensure  => present,
    require => Registry_key[$registry_path],
  }

  registry::value { 'Set default value for Startup':
    key     => "${registry_path}\Startup",
    value   => '(default)',
    data    => '',
    require => Registry_key["${registry_path}\Startup"],
  }

  registry_key { "${registry_path}\Startup\0":
    ensure  => present,
    require => Registry_key["${registry_path}\Startup"],
  }

  registry::value { 'Set default value for Startup\0':
    key     => "${registry_path}\Startup\0",
    value   => '(default)',
    data    => '',
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry_value { 'Set Startup\0 displayname':
    ensure  => present,
    path    =>Registry_key["${registry_path}\Startup\0\DisplayName"],
    data    => 'Local Group Policy',
    type    => 'string',
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry_value { 'Set Startup\0 filesyspath':
    ensure  => present,
    path    =>Registry_key["${registry_path}\Startup\0\FileSysPath"],
    data    => 'C:\Windows\System32\GroupPolicy\Machine',
    type    => 'string',
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry_value { 'Set Startup\0 gpo-id':
    ensure  => present,
    path    =>Registry_key["${registry_path}\Startup\0\GPO-ID"],
    data    => 'LocalGPO',
    type    => 'string',
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry_value { 'Set Startup\0 gponame':
    ensure  => present,
    path    =>Registry_key["${registry_path}\Startup\0\GPOName"],
    data    => 'Local Group Policy',
    type    => 'string',
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry_value { 'Set Startup\0 som-id':
    ensure  => present,
    path    =>Registry_key["${registry_path}\Startup\0\SOM-ID"],
    data    => 'Local',
    type    => 'string',
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry_value { 'Set Startup\0 psscriptorder':
    ensure  => present,
    path    =>Registry_key["${registry_path}\Startup\0\PSScriptOrder"],
    data    => 1,
    type    => 'dword',
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry_key { "${registry_path}\Startup\0\0":
    ensure  => present,
    require => Registry_key["${registry_path}\Startup\0"],
  }

  registry::value { 'Set default value for Startup\0':
    key     => "${registry_path}\Startup\0\0",
    value   => '(default)',
    data    => '',
    require => Registry_key["${registry_path}\Startup\0\0"],
  }

  registry_value { 'Set logon script':
    ensure  => 'present',
    path    => "${registry_path}\0\0\Script",
    data    => "${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}",
    type    => 'string',
    require => Registry_key["${registry_path}\0\0"],
  }

  registry_value { 'Set logon params':
    ensure  => 'present',
    path    => "${registry_path}\0\0\Parameters",
    data    => '',
    type    => 'string',
    require => Registry_key["${registry_path}\0\0"],
  }

  registry_value { 'Set logon ExecTime':
    ensure  => 'present',
    path    => "${registry_path}\0\0\ExecTime",
    data    => 0,
    type    => 'qword',
    require => Registry_key["${registry_path}\0\0"],
  }

  if $is_policy {
    registry_value { 'Set logon IsPowershell':
      ensure  => 'present',
      path    => "${registry_path}\0\0\IsPowershell",
      data    => 1,
      type    => 'dword',
      require => Registry_key["${registry_path}\0\0"],
    }
  }

  registry::value { 'Set default value':
    key     => "${registry_path}\0\0",
    value   => '(default)',
    data    => '',
    require => Registry_key["${registry_path}\0\0"],
  }
}