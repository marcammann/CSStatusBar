Pod::Spec.new do |s|
  s.name     = 'CSStatusBar'
  s.version  = '0.3.0'
  s.license  = 'Apache 2.0'
  s.summary  = 'CSStatusBar helps with showing the revision number in the status bar.'
  s.homepage = 'http://github.com/marcammann/CSStatusBar'
  s.author   = { 'Marc Ammann' => 'marc@codesofa.com' }
  s.source   = { :git => 'https://github.com/marcammann/CSStatusBar.git', :tag => '0.3.0' }
  s.description = 'CSStatusBar helps with showing the revision number in the status bar, next to other git references. Or any message you want. Swipe left and right to go to the next one.'

  s.platform = :ios
  s.source_files = "Classes"
  s.preserve_paths = "Tools"
  s.framework = 'UIKit'
  s.requires_arc = true
end
