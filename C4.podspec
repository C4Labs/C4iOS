Pod::Spec.new do |s|
  s.name         = "C4"
  s.version      = "1.0.2"
  s.summary      = "Code, Creatively."
  s.description  = <<-DESC
                    C4 is a fast prototyping and creative-coding framework.
                    It lets you build expressive user experiences and create
                    works of art.
                   DESC
  s.homepage     = "http://www.c4ios.com"
  s.license      = "MIT"
  s.authors      = { "Travis" => "info@c4ios.com", "Alejandro Isaza" => "al@isaza.ca" }

  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/C4Framework/C4iOS.git", :tag => s.version }

  s.source_files  = "C4/**/*.swift"
end
