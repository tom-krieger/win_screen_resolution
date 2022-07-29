# @summary Params class
#
#Param definitions.
#
# @example
#   include win_screen_resolution::params
class win_screen_resolution::params (
  Array $valid_screen_resolutions,
) {
  $gems         = ['fiddle']
  $script_dir   = 'C:\ProgramData\PuppetLabs\win_screen_resolution'
  $script_file  = 'set_screen_resolution.ps1'
  # $registry_key = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Logon\0\0\Script'
  $registry_key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0\Script'
}
