Pod::Spec.new do |s|  
  s.name             = "VPopImageView"  
  s.version          = "0.1.0"  
  s.summary          = "A custom imageview"  
  s.homepage         = "https://github.com/viczy/VPopImageView"   
  s.license     	 = 'MIT'
  s.author           = { "vic" => "viczy@ymail.com" }  
  s.source           = { :git => "https://github.com/viczy/VPopImageView.git", :tag => s.version.to_s }   
  
  s.platform     = :ios, '5.0'  
  
  s.source_files = 'Source/*'  
  
  s.source_files = 'Source/*.{h,m}'
  s.public_header_files = 'Source/*.h'
  s.dependency 'AFNetworking'
#  s.frameworks = 'QuartzCore', 'CoreGraphics', 'CoreText'
  s.requires_arc = true 
  
end