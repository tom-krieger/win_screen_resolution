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

  file { "${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::registry_file}":
    ensure  => file,
    content => epp('win_screen_resolution/registry.epp', {
      filesyspath => $win_screen_resolution::params::filesyspath,
      parent      => $win_screen_resolution::params::parent,
      child       => $win_screen_resolution::params::child,
      script      => "${win_screen_resolution::params::gpo_script_dir}\\\\${win_screen_resolution::params::script_file}",
    }),
    owner   => 'Administrator',
    group   => 'Administrators',
    notify  => Exec['add registry entries'],
  }

  file { $win_screen_resolution::params::psscriptsinit:
    ensure => file,
    owner  => 'Administrator',
    group  => 'Administrators',
    mode   => '0644',
  }

  local_group_policy { 'Run these programs at user logon':
    ensure          => 'present',
    policy_settings => {
      'Items to run at logon' => ["${win_screen_resolution::params::gpo_script_dir}\\\\${win_screen_resolution::params::script_file}"]
    }
  }

  # ini_setting { 'set logon script':
  #   ensure  => present,
  #   path    => $win_screen_resolution::params::psscriptsinit,
  #   section => 'Logon',
  #   setting => "${win_screen_resolution::params::child}CmdLine",
  #   value   => "${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}",
  #   require => [
  #     File["${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::script_file}"],
  #     File[$win_screen_resolution::params::psscriptsinit],
  #     File["${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::registry_file}"],
  #   ],
  # }

  # ini_setting { 'set logon parameters':
  #   ensure  => present,
  #   path    => $win_screen_resolution::params::psscriptsinit,
  #   section => 'Logon',
  #   setting => "${win_screen_resolution::params::child}Parameters",
  #   value   => '',
  #   require => Ini_setting['set logon script'],
  # }

  exec { 'add registry entries':
    command     => "reg.exe import ${win_screen_resolution::params::script_dir}\\${win_screen_resolution::params::registry_file}",
    path        => ['C:\Windows\system32;C:\Windows','C:\Windows\System32\Wbem','C:\Windows\System32\WindowsPowerShell\v1.0',
                    'C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps'],
    refreshonly => true,
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
