# [![](https://www.rosehosting.com/blog/wp-content/uploads/2014/12/mongodb-50x50.png)Stitch](https://mongodb.com/cloud/stitch)

[![Join the chat at https://gitter.im/mongodb/stitch](https://badges.gitter.im/mongodb/stitch.svg)](https://gitter.im/mongodb/stitch?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) ![iOS](https://img.shields.io/badge/platform-iOS-blue.svg) [![Swift 4.0](https://img.shields.io/badge/swift-4.0-orange.svg)](https://developer.apple.com/swift/) ![Apache 2.0 License](https://img.shields.io/badge/license-Apache%202-lightgrey.svg) [![Cocoapods compatible](https://img.shields.io/badge/pod-v1.0.0-ff69b4.svg)](#Cocoapods)

[MongoDB Stitch Users - Google Group](https://groups.google.com/d/forum/mongodb-stitch-users)

[MongoDB Stitch Announcements - Google Group](https://groups.google.com/d/forum/mongodb-stitch-announce)

## Creating a new app with the iOS SDK

### Set up an application on Stitch
1. Go to https://stitch.mongodb.com/ and log in
2. Create a new app with your desired name
3. Take note of the app's client App ID by going to Clients under Platform in the side pane
4. Go to Authentication under Control in the side pane and enable "Allow users to log in anonymously"

### Set up a project in XCode using Stitch

#### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build Stitch iOS 0.2.0+.

To integrate the iOS SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Stitch', '~> 4.0.0'
    # optional: for using the twilio service
    pod 'Stitch/Twilio', '~> 4.0.0'
end
```

Then, run the following command:

```bash
$ pod install
```

#### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate the iOS SDK into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add the iOS SDK as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/10gen/stitch-ios-sdk.git
  ```

- `cd` into stitch-ios-sdk, and run `.build.sh`. This will download the required dependencies for Stitch.

- Run `make`.

- Open the new `stitch-ios-sdk` folder, and drag the `StitchCore.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `StitchCore-iOS.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `StitchCore.xcodeproj` folders each with two different versions of the `StitchCore.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `StitchCore.framework`.

- Select the `StitchCore-iOS.framework` for iOS.

- Click on your .xcodeproj within XCode. Under the `Build Settings` tab, scroll down to `Header Search Paths` and add `$(SRCROOT)/stitch-ios-sdk/Sources/libbson` and `$(SRCROOT)/stitch-ios-sdk/Sources/libmongoc`.

- Scroll down to `Library Search Paths` and add `$(SRCROOT)/stitch-ios-sdk/MobileSDKs/iphoneos/lib`.

- For adding the other modules, `StitchCoreServicesTwilio-iOS`, follow the same process above but with the respective `.xcodeproj` files.

- And that's it!

  > The `StitchCore.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

---

### Using the SDK

#### Logging In
1. To initialize our connection to Stitch, use the static `StitchClientFactory.create()` method to asynchronously create a `StitchClient` that can be used to make requests to Stitch.

    ```swift
    StitchClientFactory
        .create(appId: "<your-client-app-id>")
        .done { (client: StitchClient) in
            // Perform requests to Stitch using the variable "client",
            // or assign the value of the variable "client" to some
            // property accessible outside this closure.

            // For example, if this is in a class which has a
            // stored StitchClient property named "stitchClient":
            self.stitchClient = client
        }.cauterize()
    ```

    This will only instantiate a client but will not make any outgoing connection to Stitch.

2. For guidance on how to perform this initialization cleanly in the context of developing an iOS app, see the page [Initialize StitchClient](https://docs.mongodb.com/stitch/getting-started/init-stitchclient/#ios-sdk) in the MongoDB Stitch documentation.

3. Since we enabled anonymous log in, let's log in with it; add the following after you've initialized your new `StitchClient`:

	```swift
	self.stitchClient.fetchAuthProviders().then { (authProviderInfo: AuthProviderInfo) in
            if (authProviderInfo.anonymousAuthProviderInfo != nil) {
                print("logging in anonymously")
                return self.stitchClient.anonymousAuth()
            } else {
                print("no anonymous provider")
            }
        }.then { (userId: String) in
            print("logged in anonymously as user \(userId)")
        }.catch { error in
            print("failed to log in anonymously: \(error)")
        }
	```

4. Now run your app in XCode by going to product, Run (or hitting ⌘R).
5. Once the app is running, open up the Debug Area by going to View, Debug Area, Show Debug Area.
6. You should see log messages like:

	```
	logging in anonymously                                                    	
	logged in anonymously as user 58c5d6ebb9ede022a3d75050
	```

#### Executing a Function

1. Once logged in, executing a function happens via the StitchClient's `executeFunction()` method

	```swift
    self.stitchClient
        .executeFunction(name: "echoArg", args: "Hello world!")
        .done { (echoedArg: Any) in
            print(echoedArg as? String ?? "return value not a string")
        }.catch { error in
            print("Could not execute function: \(error)")
        }
	```

2. If you've configured your Stitch application to have a function named "echoArg" that returns its argument, you should see a message like:

	```
	Hello world!
	```

#### Set up Push Notifications (GCM)

##### Set up a GCM provider

1. Create a Firebase Project
2. Click Add Firebase to your iOS app
3. Skip downloading the config file
4. Skip adding the Firebase SDK
5. Click the gear next to overview in your Firebase project and go to Project Settings
6. Go to Cloud Messaging and take note of your Legacy server key and Sender ID
7. In Stitch go to the Notifications section and enter in your API Key (legacy server key) and Sender ID

##### Receive Push Notifications in iOS

1. Currently, StitchGCM needs to be added as a submodule.

2. To create a GCM Push Provider by asking Stitch, you must use the *getPushProviders* method and ensure a GCM provider exists:

```swift
self.stitchClient.getPushProviders().done { (result: AvailablePushProviders) in
    if let gcm = result.gcm {
        let listener = MyGCMListener(gcmClient: StitchGCMPushClient(stitchClient: self.stitchClient, info: gcm))

	StitchGCMContext.sharedInstance().application(application,
						      didFinishLaunchingWithOptions: launchOptions,
						      gcmSenderID: "<YOUR-GCM-SENDER-ID>",
						      stitchGCMDelegate: listener)
    }
}
```

3. To begin listening for notifications, set your `StitchGCMDelegate` to the StitchGCMContext:

```swift
class MyGCMDelegate: StitchGCMDelegate {
    let gcmClient: StitchGCMPushClient
        
    init(gcmClient: StitchGCMPushClient) {
        self.gcmClient = gcmClient
    }
        
    func didFailToRegister(error: Error) {
            
    }
        
    func didReceiveToken(registrationToken: String) {
            
    }
        
    func didReceiveRemoteNotification(application: UIApplication, 
				      pushMessage: PushMessage,
				      handler: ((UIBackgroundFetchResult) -> Void)? 
									  
    }
}
```

4. To register for push notifications, use the *registerToken* method on your StitchClient:

```swift
func didReceiveToken(registrationToken: String) {
    gcmClient.registerToken(token: registrationToken)
}
```
