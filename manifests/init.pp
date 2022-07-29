# @summary Set windows screen resolution
#
# The current screen resolution is szored as a fact.
# To set the new scren resolution a gpo logon script will be created
# and added to the registry.
#
# @param width
#    Screen resolution width
# @param height
#    Screen resolution height
# @param install_agent_gems
#    Install needed gems into Puppet agent
#
# @example
#   class { 'win_screen_resolution':
#      width              => 1600,
#      height             => 1200,
#      install_agent_gems => true,
#  }
class win_screen_resolution (
  Integer $width,
  Integer $height,
  Boolean $install_agent_gems = false,
) {
  include win_screen_resolution::params

  $areas = ['policy', 'state']
  $registry = {
    'policy' => $win_screen_resolution::params::policy_registry_path,
    'state'  => $win_screen_resolution::params::state_registry_path,
  }

  if $install_agent_gems {
    $win_screen_resolution::params::gems.each |$gem| {

      package { $gem:
        ensure   => 'present',
        provider => 'puppet_gem',
      }
    }
  }

  $vgl = "${width} x ${height}"
  if ! ($vgl in $win_screen_resolution::params::valid_screen_resolutions) {
    fail("Screen resolution ${vgl} is invalid.")
  }

  file { $win_screen_resolution::params::script_dir:
    ensure => directory,
    owner  => 'Administrator',
    group  => 'Administrator',
  }

  file { "${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}":
    ensure  => file,
    content => epp('win_screen_resolution/set_screen_resolution.epp', {
      width  => $width,
      height => $height,
    }),
    owner   => 'Administrator',
    group   => 'Administrator',
    require => File[ $win_screen_resolution::params::script_dir],
  }

  $areas.each |$area| {

    registry_key { "${area}-${registry[$area]}":
      ensure  => present,
      require => File["${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}"]
    }

    registry_key { "${area}-${registry[$area]}\Shutdown":
      ensure  => present,
      require => Registry_key[$registry[$area]],
    }

    registry::value { "${area}-Set default value for Shutdown":
      key     => "${registry[$area]}\Shutdown",
      value   => '(default)',
      data    => '',
      require => Registry_key["${registry[$area]}\Shutdown"],
    }

    registry_key { "${area}-${registry[$area]}\Startup":
      ensure  => present,
      require => Registry_key[$registry[$area]],
    }

    registry::value { "${area}-Set default value for Startup":
      key     => "${registry[$area]}\Startup",
      value   => '(default)',
      data    => '',
      require => Registry_key["${registry[$area]}\Startup"],
    }

    registry_key { "${area}-${registry[$area]}\Startup\0":
      ensure  => present,
      require => Registry_key["${registry[$area]}\Startup"],
    }

    registry::value { "${area}-Set default value for Startup\0":
      key     => "${registry[$area]}\Startup\0",
      value   => '(default)',
      data    => '',
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry_value { "${area}-Set Startup\0 displayname":
      ensure  => present,
      path    =>Registry_key["${registry[$area]}\Startup\0\DisplayName"],
      data    => 'Local Group Policy',
      type    => 'string',
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry_value { "${area}-Set Startup\0 filesyspath":
      ensure  => present,
      path    =>Registry_key["${registry[$area]}\Startup\0\FileSysPath"],
      data    => 'C:\Windows\System32\GroupPolicy\Machine',
      type    => 'string',
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry_value { "${area}-Set Startup\0 gpo-id":
      ensure  => present,
      path    =>Registry_key["${registry[$area]}\Startup\0\GPO-ID"],
      data    => 'LocalGPO',
      type    => 'string',
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry_value { "${area}-Set Startup\0 gponame":
      ensure  => present,
      path    =>Registry_key["${registry[$area]}\Startup\0\GPOName"],
      data    => 'Local Group Policy',
      type    => 'string',
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry_value { "${area}-Set Startup\0 som-id":
      ensure  => present,
      path    =>Registry_key["${registry[$area]}\Startup\0\SOM-ID"],
      data    => 'Local',
      type    => 'string',
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry_value { "${area}-Set Startup\0 psscriptorder":
      ensure  => present,
      path    =>Registry_key["${registry[$area]}\Startup\0\PSScriptOrder"],
      data    => 1,
      type    => 'dword',
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry_key { "${area}-${registry[$area]}\Startup\0\0":
      ensure  => present,
      require => Registry_key["${registry[$area]}\Startup\0"],
    }

    registry::value { "${area}-Set default value for Startup\0\0":
      key     => "${registry[$area]}\Startup\0\0",
      value   => '(default)',
      data    => '',
      require => Registry_key["${registry[$area]}\Startup\0\0"],
    }

    registry_value { "${area}-Set logon script":
      ensure  => 'present',
      path    => "${registry[$area]}\0\0\Script",
      data    => "${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}",
      type    => 'string',
      require => Registry_key["${registry[$area]}\0\0"],
    }

    registry_value { "${area}-Set logon params":
      ensure  => 'present',
      path    => "${registry[$area]}\0\0\Parameters",
      data    => '',
      type    => 'string',
      require => Registry_key["${registry[$area]}\0\0"],
    }

    registry_value { "${area}-Set logon ExecTime":
      ensure  => 'present',
      path    => "${registry[$area]}\0\0\ExecTime",
      data    => 0,
      type    => 'qword',
      require => Registry_key["${registry[$area]}\0\0"],
    }

    if $area == 'policy' {
      registry_value { "${area}-Set logon IsPowershell":
        ensure  => 'present',
        path    => "${registry[$area]}\0\0\IsPowershell",
        data    => 1,
        type    => 'dword',
        require => Registry_key["${registry[$area]}\0\0"],
      }
    }

    registry::value { "${area}-Set default value":
      key     => "${registry[$area]}\0\0",
      value   => '(default)',
      data    => '',
      require => Registry_key["${registry[$area]}\0\0"],
    }

  }

  # win_screen_resolution::set_registry_values { 'policy':
  #   registry_path => $win_screen_resolution::params::policy_registry_path,
  #   area          => 'policy',
  # }

  # win_screen_resolution::set_registry_values { 'state':
  #   registry_path => $win_screen_resolution::params::state_registry_path,
  #   area          => 'state',
  # }

}
