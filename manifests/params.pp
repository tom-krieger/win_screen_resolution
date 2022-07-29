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
  $script_dir           = 'C:\ProgramData\PuppetLabs\win_screen_resolution'
  $script_file          = 'set_screen_resolution.ps1'
  $state_registry_path  = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts'
  $policy_registry_path = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts'
}
