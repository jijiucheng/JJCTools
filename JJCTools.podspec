Pod::Spec.new do |s|

    s.name          = 'JJCTools'
    s.version       = '1.0.0'
    s.summary       = 'JJCTools with swift.'
    s.description  = <<-DESC
                        A Library for iOS to  get result fasterly with some methods.
                        DESC
    s.homepage      = 'https://github.com/jijiucheng/JJCTools'
    s.license       = { :type => 'MIT', :file => 'LICENSE' }
    s.authors       = { '苜蓿鬼仙' => '302926124@qq.com' }
    s.source        = { :git => 'https://github.com/jijiucheng/JJCTools.git', :tag => s.version }
    s.platform      = :ios, '10.0'
    s.ios.deployment_target = '10.0'
    s.source_files  = 'JJCTools/JJCTools/Sources/**/*.swift'

end
