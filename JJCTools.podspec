# podspec 规范文档：https://guides.cocoapods.org/syntax/podspec.html#specification
# 参考文章：https://www.jianshu.com/p/1f56c3d78b52
# pod成功的库，每个子文件夹都是对应一个子库，子库的目的是为了防止一个 kit 太大，把功能模块都分出来减少包体积；所以子库原则上是不进行相互依赖的；如果库中有必须依赖的话，可以通过该方式进行依赖；其中依赖的对应为 pod 成功后显示的库路径，非真实路径
# 删除指定版本：https://www.jianshu.com/p/e3d91ebcc38e

Pod::Spec.new do |s|

    s.name           = 'JJCTools'
    s.version        = '1.0.1'
    s.summary        = 'A Library for iOS to  get result fasterly with some methods.'
    s.homepage       = 'https://github.com/jijiucheng/JJCTools'
    s.license        = { :type => 'MIT', :file => 'LICENSE' }
    s.authors        = { '苜蓿鬼仙' => '302926124@qq.com' }
    s.source         = { :git => 'https://github.com/jijiucheng/JJCTools.git', :tag => s.version }
    s.platform       = :ios, '13.0'
    s.swift_versions = '5.10'
    s.source_files   = 'JJCTools/JJCTools/Sources/**/*.swift'
    s.resource       = 'JJCTools/JJCTools/Sources/Resources/JJCTools.bundle'
    # 依赖系统库，建议添加上，不然得话会报一些错误
    s.framework      = 'UIKit', 'Foundation'
    
    # 依赖三方库，根据需求进行添加
    # s.dependency 'PKHUD'

    # Note：可以通过如下创建子级库，在 pod 的后会形成文件夹
    # 一级子目录结构
    # s.subspec 'Category' do |ss|
    #     ss.source_files = 'JJCTools/JJCTools/Sources/Category/**/*.{swift}'
    # end

end
