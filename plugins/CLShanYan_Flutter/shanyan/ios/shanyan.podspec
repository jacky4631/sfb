#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'shanyan'
  s.version          = '2.3.4.5'
  s.summary          = '闪验SDK Flutter plguin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://shanyan.253.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { '253' => 'app@253.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.static_framework = true
  s.ios.dependency 'CL_ShanYanSDK', '~> 2.3.6.5'
  s.ios.deployment_target = '8.0'
end

