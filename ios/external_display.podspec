#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint external_screen.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'external_screen'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for managing external displays and screens.'
  s.description      = <<-DESC
A Flutter plugin that enables developers to detect, manage, and display content on external displays/screens connected via HDMI, wireless display, or other connections on iOS and Android platforms.
                       DESC
  s.homepage         = 'https://github.com/krishnapalsendhav/external_display'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Krishna Pal Sendhav' => 'krishnapalsendhav@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
