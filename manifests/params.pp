# @summary Params class
#
# Param definitions.
#
# @param valid_screen_resolutions
#    The valid screen resources
#
# @example
#   include win_screen_resolution::params
class win_screen_resolution::params (
  Array $valid_screen_resolutions,
) {
  $gems                 = ['fiddle']
  #$script_dir           = 'C:\ProgramData\PuppetLabs\win_screen_resolution'

  if $facts['operatingsystem'].downcase() == 'windows' {

    $script_dir = $facts['operatingsystemmajrelease'] ? {
      '2019'  => 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp',
      default => 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp',
    }
  } else {
    fail("OS ${facts['operatingsyetem']} not siupported!")
  }

  $script_file          = 'set_screen_resolution.ps1'
  $state_registry_path  = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts'
  $policy_registry_path = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts'
}
