# @summary Set windows screen resolution
#
# Check the current screen resolution using a fact and set the new
# resolution if not yet present.
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

  if has_key($facts, 'win_screen_resolution') {

    if  $facts['win_screen_resolution']['width'] != $width or
        $facts['win_screen_resolution']['height'] != $height
    {
      echo { 'Set resolution':
        message  => "Setting screen resolution to ${width} x ${height}",
        loglevel => 'info',
        withpath => false,
      }

      exec { 'rename-guest':
        command   => "Set-DisplayResolution -Height ${height} -Width ${width} -Force",
        provider  => powershell,
        logoutput => true,
      }
    }

  } else {

    echo { 'Fact win_screen_resolution is missing':
      message  => 'Fact win_screen_resolution is missing',
      loglevel => 'warning',
      withpath => false,
    }

  }
}
