Pod::Spec.new do |s|
  s.name         = "BCommon"
  s.version      = "0.1"
  s.summary      = "Lavatech common libs, this lib just use for our internal projects."
  s.homepage     = "http://github.com/baboy/BCommon"
  s.author       = { "baboy" => "baboyzyh@gmail.com" }
  s.source       = { :git => "https://github.com/baboy/BCommon.git", :tag => "0.1" }
  s.license      = { :type => 'Custom', :text => 'Copyright (C) 2010 Apple Inc. All Rights Reserved.' }
  s.platform     = :ios

  s.source_files = 'BCommon/BCommon-Prefix.h', 'BCommon/Classes', 'BCommon/Classes/**/*.{h,m}', 'BCommon/Classes/common/conf/G.h', 'BCommon/Classes/common/**/*.{h,m}', 'BCommon/Classes/common/conf/*'
  s.frameworks = 'UIKit', 'QuartzCore'
  s.library   = 'libsqlite'
   s.dependency 'JSONKit'
   s.dependency 'FMDB'
   s.dependency 'Reachability'
   s.dependency 'RegexKitLite'
end
