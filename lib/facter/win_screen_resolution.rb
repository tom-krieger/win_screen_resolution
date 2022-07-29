Facter.add('win_screen_resolution') do
  confine osfamily: :windows
  setcode do
    require 'fiddle'

    usr32 = Fiddle.dlopen('user32')
    gsm = Fiddle::Function.new(usr32['GetSystemMetrics'], [Fiddle::TYPE_LONG], Fiddle::TYPE_LONG)
    ret = {}
    ret['width']  = gsm.call(0)
    ret['height'] = gsm.call(1)
    ret
  end
end
