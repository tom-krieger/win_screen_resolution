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

  if $install_agent_gems {
    $win_screen_resolution::params::gems.each |$gem| {

      package { $gem:
        ensure   => 'present',
        provider => 'puppet_gem',
      }
    }
  }

  windowsfeature { 'GPMC':
    ensure                 => present,
    installmanagementtools => true,
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

  # win_screen_resolution::set_registry_values { 'policy':
  #   registry_path => $win_screen_resolution::params::policy_registry_path,
  #   area          => 'policy',
  # }

  # win_screen_resolution::set_registry_values { 'state':
  #   registry_path => $win_screen_resolution::params::state_registry_path,
  #   area          => 'state',
  # }

}
