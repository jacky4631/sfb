#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_ali_face_verify.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ali_face_verify'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for Ali face verify'
  s.description      = <<-DESC
Flutter plugin for Ali face verify
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  s.dependency 'AntVerify', '1.0.0.230307112238'

end
