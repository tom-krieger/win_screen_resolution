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
  $gems                   = ['fiddle']
  $script_dir             = 'C:\ProgramData\PuppetLabs\win_screen_resolution'
  $script_file            = 'set_screen_resolution.ps1'
  $registry_file          = 'reg_entries.reg'
  $filesyspath            = 'C:\\Windows\\System32\\GroupPolicy\\User'
  $state_registry_path    = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts'
  $policy_registry_path   = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\Scripts'
  $local_policy_logon_dir = 'C:\Windows\System32\GroupPolicy\User\Scripts\Logon'
  $parent                 = 0
  $child                  = 0
  $psscriptsinit          = 'C:\Windows\System32\GroupPolicy\User\Scripts\psscripts.ini'
}
