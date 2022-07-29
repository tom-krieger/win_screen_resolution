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
# @param install_agent_gemg
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

  registry_value { 'Set logon script':
    ensure  => 'present',
    path    => $win_screen_resolution::params::registry_key,
    data    => "${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}",
    type    => 'string',
    require => File["${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}"]
  }

}
