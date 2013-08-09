Pod::Spec.new do |s|
  s.name         = "BCommon"
  s.version      = "0.32"
  s.summary      = "Lavatech common libs, this lib just use for our internal projects."
  s.homepage     = "http://github.com/baboy/BCommon"
  s.author       = { "baboy" => "baboyzyh@gmail.com" }
  s.source       = { :git => "https://github.com/baboy/BCommon.git", :tag => "0.32" }
  s.platform     = :ios

  s.source_files = 'BCommon/Classes/*.{h,m}'


  s.subspec 'base' do |base|    
    base.source_files = 'BCommon/Classes/base'
  end
  s.subspec 'modules' do |mod|
	mod.source_files = 'BCommon/Classes/modules'
	mod.subspec 'AFNetworking' do |af|
		af.source_files = 'BCommon/Classes/modules/AFNetworking'
	end
	mod.subspec 'share' do |share|
		share.source_files = 'BCommon/Classes/modules/share'
	end
	mod.subspec 'sliding menu' do |sld|
		sld.source_files = 'BCommon/Classes/modules/sliding menu'
	end
  end
  s.subspec 'model' do |model|
	model.source_files = 'BCommon/Classes/model'
	model.subspec 'member' do |member|
		member.source_files = 'BCommon/Classes/model/member'
	end
  end
  s.subspec 'common' do |common|     
    common.subspec 'categories' do |cate|
    	cate.source_files = 'BCommon/Classes/common/categories'
    end 
    common.subspec 'conf' do |conf|
    	conf.source_files = 'BCommon/Classes/common/conf'
    end 
    common.subspec 'dao' do |dao|
    	dao.source_files = 'BCommon/Classes/common/dao'
    end 
    common.subspec 'ext' do |ext|
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
		web.prefix_header_file = "BCommon/BCommon-Prefix.pch"
    end
  end

  s.frameworks = 'UIKit', 'QuartzCore', 'CFNetwork', 'AVFoundation', 'CoreFoundation', 'CoreGraphics', 'Security', 'AudioToolbox', 'MediaPlayer', 'MobileCoreServices', 'SystemConfiguration', 'CoreMedia', 'Mapkit', 'CoreLocation', 'MessageUI', 'ImageIO'

  s.libraries   = 'sqlite3.0', 'xml2', 'icucore', 'z'

end
