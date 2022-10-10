Pod::Spec.new do |spec|

  spec.name         = "Toaster"
  spec.version      = "1.0.2"
  spec.summary      = "SwiftUI view modifier mimicking an Android 'Toast'"
  spec.description  = <<-DESC
                    SwiftUI view modifier mimicking an Android 'Toast'
                    DESC

  spec.homepage     = "https://github.com/gfranks/Toaster.git"
  spec.license      = { :type => "MIT" }
  spec.author       = { "Garrett Franks" => "lgfz71@gmail.com" }
  spec.ios.deployment_target = "14.0"
  spec.osx.deployment_target = "12.0"
  spec.source       = { :git => "https://github.com/gfranks/Toaster.git", :tag => "#{spec.version}" }
  spec.source_files = 'Sources/**/*.{h,m,swift}'

end
  
