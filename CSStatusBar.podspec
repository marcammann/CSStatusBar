#
# Be sure to run `pod spec lint CSStatusBar.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec.
#
Pod::Spec.new do |s|
  s.name     = 'CSStatusBar'
  s.version  = '0.1.0'
  s.license  = 'MIT'
  s.summary  = 'CSStatusBar helps with showing the revision number in the status bar, next to other git references. Or any message you want. Swipe left and right to go to the next one.'
  s.homepage = 'http://github.com/marcammann/CSStatusBar'
  s.author   = { 'Marc Ammann' => 'marc@codesofa.com' }

  s.source   = { :git => 'git://github.com/marcammann/CSStatusBar.git', :tag => '0.1.1' }

  s.description = 'CSStatusBar helps with showing the revision number in the status bar, next to other git references. Or any message you want. Swipe left and right to go to the next one.'

  s.platform = :ios

  s.source_files = '**.{h,m}'

  s.framework = 'UIKit'

  s.requires_arc = true
end
