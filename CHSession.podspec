
Pod::Spec.new do |s|
  s.name             = 'CHSession'
  s.version          = '1.0.1'
  s.summary          = 'Cache Manager for request around NSURLSession'

  s.description      = <<-DESC
Cache Manager for GET, POST, HEAD request and manage this responce chache in memory or in disk.
                       DESC

  s.homepage         = 'https://github.com/vkrotin/CHSession'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aleksey Anisimov' => 'vkrotin.ios@gmail.com' }
  s.source           = { :git => 'https://github.com/vkrotin/CHSession.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'CHSession/**/*'

  s.frameworks = 'UIKit', 'Foundation'

end
