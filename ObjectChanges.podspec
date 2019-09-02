Pod::Spec.new do |s|
  s.name         = "ObjectChanges"
  s.version      = "1.0.5"
  s.summary      = "A project that listens for changes in all properties of an object."
  s.homepage     = "https://github.com/GodL/ObjectChanges"
  s.framework = "Foundation"
  s.license      = "MIT"
  s.author             = { "GodL" => "547188371@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/GodL/ObjectChanges.git", :tag => s.version.to_s }
  s.source_files  = "ObjectChangesDemo/ObjectChanges/*.{h,m}"
  s.requires_arc = true
end
