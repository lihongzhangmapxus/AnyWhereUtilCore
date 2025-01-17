

Pod::Spec.new do |s|
  version = '1.0.1'

  s.name             = 'AnywhereUtilCore'
  s.version          = version
  s.summary          = 'Anywhere project common basic library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Project common basic library, separate modules
                       DESC

  s.homepage         = 'https://www.mapxus.com'
  s.author       = { 'Mapxus' => 'developer@maphive.io' }
  s.source       = { :http => "https://nexus3.mapxus.com/repository/dropin-ui-ios/#{version.to_s}/dropin-ui-sdk-ios.zip", :flatten => true }
  s.platform     = :ios, '13.0'

  s.source_files = 'AnywhereUtilCore/**/*.{h,swift}'
  s.resource_bundles = {
      'AnywhereUtilCore' => ['AnywhereUtilCore/**/*.{xcassets}']
  }
  
  s.frameworks = 'UIKit'
  s.module_name  = 'AnywhereUtilCore'

  s.dependency "Kingfisher", "8.0.3"
#  s.dependency "AFNetworking/Serialization", "~> 4.0.0"
#  s.dependency "AFNetworking/Security", "~> 4.0.0"
#  s.dependency "AFNetworking/Reachability", "~> 4.0.0"
#  s.dependency "AFNetworking/NSURLSession", "~> 4.0.0"
  s.dependency "AFNetworking/UIKit", "~> 4.0.0"
  
end

