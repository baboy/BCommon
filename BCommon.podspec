Pod::Spec.new do |s|
  s.name         = "BCommon"
  s.version      = "0.1"
  s.summary      = "Lavatech common libs, this lib just use for our internal projects."
  s.homepage     = "http://github.com/baboy/BCommon"
  s.author       = { "baboy" => "baboyzyh@gmail.com" }
  s.source       = { :git => "https://github.com/baboy/BCommon.git", :tag => "0.1" }
  s.license      = { :type => 'Custom', :text => 'Copyright (C) 2010 Apple Inc. All Rights Reserved.' }
  s.platform     = :ios

  s.source_files = 'BCommon/Classes/*.{h,m}'
  s.subspec 'Base' do |base|    
    base.source_files = 'BCommon/Classes/base'
  end
  s.subspec 'Common' do |common|     
    common.subspec 'Asi' do |asi|
    	asi.source_files = 'BCommon/Classes/common/asi'
    	asi.subspec 'CloudFiles' do |CloudFiles|
    		CloudFiles.source_files = 'BCommon/Classes/common/asi/CloudFiles'
    	end
    	asi.subspec 'S3' do |s3|
    		s3.source_files = 'BCommon/Classes/common/asi/S3'
    	end
    end 
    common.subspec 'Conf' do |conf|
    	conf.source_files = 'BCommon/Classes/common/conf'
    end 
    common.subspec 'Dao' do |dao|
    	dao.source_files = 'BCommon/Classes/common/dao'
    end 
    common.subspec 'Ext' do |ext|
    	ext.source_files = 'BCommon/Classes/common/ext'
    end
    common.subspec 'Map' do |map|
    	map.source_files = 'BCommon/Classes/common/map'
    end
    common.subspec 'Network' do |network|
    	network.source_files = 'BCommon/Classes/common/network'
    end
    common.subspec 'UI' do |ui|
    	ui.source_files = 'BCommon/Classes/common/ui'
    end
    common.subspec 'Utils' do |utils|
    	utils.source_files = 'BCommon/Classes/common/utils'
    end
    common.subspec 'Web' do |web|
    	web.source_files = 'BCommon/Classes/common/web'
    end
  end

  s.frameworks = 'UIKit', 'QuartzCore', 'CFNetwork', 'AVFoundation', 'CoreFoundation', 'CoreGraphics', 'Security', 'AudioToolbox', 'MediaPlayer', 'MobileCoreServices', 'SystemConfiguration', 'CoreMedia', 'Mapkit', 'CoreLocation', 'MessageUI', 'ImageIO'

  s.libraries   = 'sqlite3.0', 'xml2', 'icucore', 'z'

  s.dependency 'JSONKit'
  s.dependency 'FMDB'
  s.dependency 'Reachability'
  s.dependency 'RegexKitLite'
end
#Pod::Spec.new do |s|
#  s.name         = "BCommon"
#  s.version      = "0.1"
#  s.summary      = "Lavatech common libs, this lib just use for our internal projects."
#  s.homepage     = "http://github.com/baboy/BCommon"
#  s.author       = { "baboy" => "baboyzyh@gmail.com" }
#  s.source       = { :git => "https://github.com/baboy/BCommon.git", :tag => "0.1" }
#  s.license      = { :type => 'Custom', :text => 'Copyright (C) 2010 Apple Inc. All Rights Reserved.' }
#  s.platform     = :ios
#
#  s.source_files = 'BCommon/BCommon-Prefix.h', 'BCommon/Classes', 'BCommon/Classes/**/*.{h,m}', 'BCommon/Classes/common/conf/G.h', 'BCommon/Classes/common/**/*.{h,m}', 'BCommon/Classes/common/conf/*'
#  s.frameworks = 'UIKit', 'QuartzCore'
#  s.library   = 'libsqlite'
#   s.dependency 'JSONKit'
#   s.dependency 'FMDB'
#   s.dependency 'Reachability'
#   s.dependency 'RegexKitLite'
#end
