

Pod::Spec.new do |s|
  version = '1.1.5'

  s.name             = 'AnywhereUtilCore'
  s.version          = version
  s.summary          = 'Anywhere project common basic library'
  s.license      = { :type => 'BSD 3-Clause', :file => 'LICENSE' }
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Project common basic library, separate modules
                       DESC

  s.homepage         = 'https://www.mapxus.com'
  s.author       = { 'Maxus' => 'developer@maphive.io' }
  s.platform     = :ios, '13.0'

  s.source           = { :git => 'https://github.com/lihongzhangmapxus/AnyWhereUtilCore.git', :tag => version.to_s }

  s.requires_arc = true

  s.source_files = 'AnywhereUtilCore/Classes/**/*'
  s.resource_bundles = {
      'AnywhereUtilCore' => [
          'AnywhereUtilCore/Assets/**/*.{xcassets,ttf}'
      ]
  }
  
  s.module_name  = 'AnywhereUtilCore'

  s.dependency "AFNetworking/Serialization", "~> 4.0.0"
  s.dependency "AFNetworking/Security", "~> 4.0.0"
  s.dependency "AFNetworking/Reachability", "~> 4.0.0"
  s.dependency "AFNetworking/NSURLSession", "~> 4.0.0"
  s.dependency "AFNetworking/UIKit", "~> 4.0.0"

  # 修复模拟器和优化级别的警告
  s.swift_version = '5.0'
  s.pod_target_xcconfig = {
    'IPHONEOS_DEPLOYMENT_TARGET' => '13.0',
  }

end

