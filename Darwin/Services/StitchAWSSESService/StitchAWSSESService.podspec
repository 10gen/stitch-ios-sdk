Pod::Spec.new do |spec|
    spec.name       = File.basename(__FILE__, '.podspec')
    spec.version    = "4.0.6"
    spec.summary    = "#{__FILE__} Module"
    spec.homepage   = "https://github.com/mongodb/stitch-ios-sdk"
    spec.license    = "Apache2"
    spec.authors    = {
      "Jason Flax" => "jason.flax@mongodb.com",
      "Adam Chelminski" => "adam.chelminski@mongodb.com",
      "Eric Daniels" => "eric.daniels@mongodb.com",
    }
    spec.source     = {
      :git => "https://github.com/mongodb/stitch-ios-sdk.git",
      :branch => "master", 
      :tag => '4.0.6'
    }
  
    spec.platform = :ios, "11.0"
    spec.platform = :tvos, "10.2"

    spec.platform = :macos, "10.10"

    
    spec.ios.deployment_target = "11.0"
    spec.tvos.deployment_target = "10.2"

    spec.macos.deployment_target = "10.10"
  
    spec.source_files = "Darwin/Services/#{spec.name}/#{spec.name}/**/*.swift"

    spec.dependency 'StitchCore', '~> 4.0.6'
    spec.dependency 'StitchCoreAWSSESService', '~> 4.0.6'
end
