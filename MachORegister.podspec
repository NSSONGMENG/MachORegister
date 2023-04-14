Pod::Spec.new do |s|
  s.name             = 'MachORegister'
  s.version          = '0.1'
  s.summary          = 'MDMachORegister'

  s.description      = "iOS可执行文件注册共享k-v管理"

  s.homepage         = 'https://github.com/NSSONGMENG/MachORegister.git'
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { 'song.meng' => '740621245@qq.com' }
  s.source           = { :git => 'https://github.com/NSSONGMENG/MachORegister.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'MachORegister/*.{h,m}'
  s.framework = 'UIKit', 'Foundation'
end
