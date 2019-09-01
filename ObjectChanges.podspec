Pod::Spec.new do |s|
  s.name         = "ObjectChanges"
  s.version      = "1.0.1"
  s.summary      = "A project that listens for changes in all properties of an object."
  s.homepage     = "https://github.com/GodL/ObjectChanges"
  s.frameworks = 'Foundation','ObjectiveC'
  s.license      = "MIT"
  s.author             = { "GodL" => "547188371@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/GodL/ObjectChanges.git", :tag => s.version.to_s }
  s.source_files  = "ObjectChangesDemo/ObjectChanges/*.{h,m}"
  s.public_header_files = 'ObjectChangesDemo/ObjectChanges/ObjectChanges.h'
  s.requires_arc = true
end
