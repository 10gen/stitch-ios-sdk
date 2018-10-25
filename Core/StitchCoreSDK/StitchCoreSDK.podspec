Pod::Spec.new do |spec|
    spec.name       = File.basename(__FILE__, '.podspec')
    spec.version    = "4.0.7-alpha.0"
    spec.summary    = "#{__FILE__} Module"
    spec.homepage   = "https://github.com/mongodb/stitch-ios-sdk"
    spec.license    = "Apache2"
    spec.authors    = {
      "Jason Flax" => "jason.flax@mongodb.com",
      "Adam Chelminski" => "adam.chelminski@mongodb.com",
      "Eric Daniels" => "eric.daniels@mongodb.com",
    }

    spec.source = {
      :git => "https://github.com/jsflax/stitch-ios-sdk.git",
      :branch => "4.0.7-alpha.0"
    }

    spec.platform = :ios, "11.0"
    # spec.platform = :tvos, "10.2"
    # spec.platform = :macos, "10.10"
    spec.swift_version = '4.2'
    
    # spec.user_target_xcconfig = {
    #   'FRAMEWORK_SEARCH_PATHS' => "$(PODS_ROOT)/#{spec.name}/Frameworks/ios"
    # }
    spec.ios.deployment_target = "11.0"
    # spec.tvos.deployment_target = "10.2"
    # spec.macos.deployment_target = "10.10"

    # spec.ios.vendored_frameworks = 'Frameworks/ios/*.framework'
    # spec.tvos.vendored_frameworks = 'Frameworks/tvos/*.framework'
    # spec.macos.vendored_frameworks = 'Frameworks/macos/*.framework'
    
    spec.dependency 'MongoSwift', '0.0.4'
    
    spec.source_files = "Core/#{spec.name}/Sources/#{spec.name}/**/*.swift"
end
