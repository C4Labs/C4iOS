Pod::Spec.new do |s|
  s.name         = "C4"
  s.version      = "3.0.0"
  s.summary      = "Code, Creatively."
  s.description  = <<-DESC
                    C4 is an open-source creative coding framework that harnesses the power 
                    of native iOS programming with a simplified API that gets you working 
                    with media right away. Build artworks, design interfaces and explore 
                    new possibilities working with media and interaction.
                    DESC
  s.homepage     = "http://www.c4ios.com"
  s.license      = "MIT"
  s.authors      = { "Travis" => "info@c4ios.com", "Alejandro Isaza" => "al@isaza.ca" }

  s.ios.deployment_target = '9.3'
  s.tvos.deployment_target = '9.3'

  s.source = { :git => "https://github.com/C4Labs/C4iOS.git", :tag => s.version }

  s.source_files = "C4/**/*.swift"
  s.tvos.exclude_files = 'C4/UI/UIGestureRecognizer+Closure.swift', 'C4/UI/View+Gestures.swift', 'C4/UI/Camera.swift'
end
