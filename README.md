![iOS](https://img.shields.io/badge/platform-iOS-blue.svg) [![Swift 4.0](https://img.shields.io/badge/swift-4.1-orange.svg)](https://developer.apple.com/swift/) ![Apache 2.0 License](https://img.shields.io/badge/license-Apache%202-lightgrey.svg) [![Cocoapods compatible](https://img.shields.io/badge/pod-v5.1.0-ff69b4.svg)](#CocoaPods)

# MongoDB Stitch iOS/Swift SDK 

The official [MongoDB Stitch](https://stitch.mongodb.com/) SDK for iOS/Swift.

### Index
- [Documentation](#documentation)
- [Discussion](#discussion)
- [Installation](#installation)
- [Example Usage](#example-usage)

## Documentation
* [API/Jazzy Documentation](https://docs.mongodb.com/stitch-sdks/swift/5.1.0/index.html)
* [MongoDB Stitch Documentation](https://docs.mongodb.com/stitch/)

## Discussion
* [MongoDB Stitch Users - Google Group](https://groups.google.com/d/forum/mongodb-stitch-users)
* [MongoDB Stitch Announcements - Google Group](https://groups.google.com/d/forum/mongodb-stitch-announce)

## Installation

### Xcode/iOS

#### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

- Note: CocoaPods 1.6.0+ is required to build the Stitch iOS SDK 5.0+.

To integrate the iOS SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    # For core functionality and the Remote MongoDB Service
    pod 'StitchSDK', '= 5.1.0'

    # optional: for using the AWS service
    pod 'StitchSDK/StitchAWSService', '= 5.1.0'
    # optional: for using the Firebase Cloud Messaging service
    pod 'StitchSDK/StitchFCMService', '= 5.1.0'
    # optional: for using the HTTP service
    pod 'StitchSDK/StitchHTTPService', '= 5.1.0'
    # optional: for using the twilio service
    pod 'StitchSDK/StitchTwilioService', '= 5.1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

Open the `.xcworkspace` file generated by `pod install` to access your project with all of its necessary Stitch dependencies automatically linked.

## Example Usage

### Creating a new app with the SDK (iOS)

#### Set up an application on Stitch
1. Go to [https://stitch.mongodb.com/](https://stitch.mongodb.com/) and log in to MongoDB Atlas.
2. Create a new app in your project with your desired name.
3. Go to your app in Stitch via Atlas by clicking 'Stitch' in the left side pane and clicking your app.
3. Copy your Stitch App ID from the top of the left side pane.
4. Enable anonymous authentication by going to the Users page in the left side pane, selecting the Providers tab, and enabling the "Allow users to log in anonymously" option.

#### Set up a project in Xcode/CocoaPods using Stitch

1. Download and install [Xcode](https://developer.apple.com/xcode/). 

- Note: Xcode 10.1 (10B61) is currently the maximum supported version. To install an old version of Xcode, see [https://developer.apple.com/download/more/](https://developer.apple.com/download/more/).

2. Create a new app project with your desired name. Ensure that Swift is the selected language.

- Note: iOS 11.0 is the minimum iOS Deployment Target.

3. Navigate to the directory of the project in a command line, and run `pod init`.
4. In the `Podfile` that is generated, add the following line under the dependencies for your app target:

```ruby
    pod 'StitchSDK', '= 5.1.0'
```

See above for the list of optional Stitch service pods that you may add to your Podfile.

5. Run `pod install`.
6. Open the generated `.xcworkspace` file. Your app project will have all the necessary dependencies configured to communicate with MongoDB Stitch.
7. To use basic Stitch features, `import StitchCore` in a source file.
8. To create BSON documents and BSON values like ObjectId, `import MongoSwift` in a source file.
9. To access a remote MongoDB instance via Stitch, `import StitchRemoteMongoDBService` in a source file.

#### Using the SDK

#### Initialize the SDK
1. When your app is initialized, run the following code to initialize the Stitch SDK. The [`application(_:didFinishLaunchWithOptions)`](https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1622921-application) method of your `AppDelegate.swift` can be an appropriate place for this initialization step. Be sure to `import StitchCore`.

```swift
    // at the top of the file
    import StitchCore

    // ...

    // in `application(_:didFinishLaunchWithOptions)`
    do {
        _ = try Stitch.initializeDefaultAppClient(
            withClientAppID: "your-client-app-id"
        )
        print("Successfully initialized default Stitch app client!");
    } catch {
        // note: This initialization will only fail if an incomplete configuration is 
        // passed to a client initialization method, or if a client for a particular 
        // app ID is initialized multiple times. See the documentation of the "Stitch" 
        // class for more details.
        print("Failed to initialize MongoDB Stitch iOS SDK: \(error)")
    }
```

2. To get a client to use for logging in and communicating with Stitch, use `Stitch.defaultAppClient`.

```swift
    // in a view controller's properties, for example
    private lazy var stitchClient = Stitch.defaultAppClient!
```

##### Logging In
1. We enabled anonymous log in, so let's log in with it! Add the following anywhere in your code:

```swift
let client = Stitch.defaultAppClient!

print("logging in anonymously")
client.auth.login(withCredential: AnonymousCredential()) { result in
      switch result {
      case .success(let user):
          print("logged in anonymous as user \(user.id)")
          DispatchQueue.main.async {
              // update UI accordingly
          }
      case .failure(let error):
          print("Failed to log in: \(error)")
      }
  }
```

2. Now run your app in Xcode by going to product, Run (or hitting ⌘R).
3. Once the app is running, open up the Debug Area by going to View, Debug Area, Show Debug Area.
4. You should see log messages like:

```
logging in anonymously                                                    	
logged in anonymously as user 58c5d6ebb9ede022a3d75050
```

##### Executing a Function

1. Once logged in, you can execute a [Stitch Function](http://docs.mongodb.com/stitch/functions) with the StitchClient's `callFunction()` method:

```swift
    client.callFunction(
        withName: "echoArg", withArgs: ["Hello world!"], withRequestTimeout: 5.0
    ) { (result: StitchResult<String>) in
        switch result {
        case .success(let stringResult):
            print("String result: \(stringResult)")
        case .failure(let error):
            print("Error retrieving String: \(String(describing: error))")
        }
    }
```

2. If you've configured your Stitch application to have a function named "echoArg" that returns its argument, i.e.:

```javascript
// Stitch Function called 'echoArg'
exports = function(arg) {
  return arg;
};
```

Then you should see a message in the Xcode Debug Area like:

```
String result: Hello world!
```

##### Getting a StitchAppClient without Stitch.defaultAppClient

In the case that you don't want a single default initialized StitchAppClient, you can use the following with as many client app IDs as you'd like to initialize clients for multiple app IDs:

```swift
    do {        
        let client1 = try Stitch.initializeAppClient(withClientAppID: "your-first-client-app-id")
        
        let client2 = try Stitch.initializeAppClient(withClientAppID: "your-second-client-app-id")
    } catch {
        print("Failed to initialize MongoDB Stitch iOS SDK: \(error.localizedDescription)")
    }
```

You can use the client returned there or anywhere else in your app you can use the following:


```swift
let client1 = try! Stitch.appClient(forAppID: "your-first-client-app-id")
let client2 = try! Stitch.appClient(forAppID: "your-second-client-app-id")
```
