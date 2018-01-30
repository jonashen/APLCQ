# iOS-UILibraryDemo

## Introduction

This UILibraryDemo is design for you to gain a basic understanding of the DJI iOS UI Library. You will learn how to use DJI iOS UI Library and DJI iOS SDK to create a fully functioning mini-DJI Go app easily, with standard DJI Go UIs and functionalities. 

## Requirements

 - iOS 9.0+
 - Xcode 8.0+
 - DJI iOS SDK 4.4
 - DJI iOS UI Library 4.4

## SDK and UI Library Installation with CocoaPods

Since this project has been integrated with [DJI iOS SDK CocoaPods](https://cocoapods.org/pods/DJI-SDK-iOS) now, please check the following steps to install **DJISDK.framework** using CocoaPods after you downloading this project:

**1.** Install CocoaPods

Open Terminal and change to the download project's directory, enter the following command to install it:

~~~
sudo gem install cocoapods
~~~

The process may take a long time, please wait. For further installation instructions, please check [this guide](https://guides.cocoapods.org/using/getting-started.html#getting-started).

**2.** Install SDK with CocoaPods in the Project

Run the following command in the project's path:

~~~
pod install
~~~

If you install it successfully, you should get the messages similar to the following:

~~~
Analyzing dependencies
Downloading dependencies
Installing DJI-SDK-iOS (4.4)
Installing DJI-UILibrary-iOS (4.4)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `UILibraryDemo.xcworkspace` for this project from now on.
Pod installation complete! There is 1 dependency from the Podfile and 1 total pod
installed.
~~~

> **Note**: If you saw "Unable to satisfy the following requirements" issue during pod install, please run the following commands to update your pod repo and install the pod again:
> 
> ~~~
> pod repo update
> pod install
> ~~~

## Tutorial

For this demo's tutorial: **Getting Started with DJI UI Library**, please refer to <https://developer.dji.com/mobile-sdk/documentation/ios-tutorials/UILibraryDemo.html>.

## Feedback

We’d love to hear your feedback for this demo and tutorial.

Please use **Github Issue** or **email** [oliver.ou@dji.com](oliver.ou@dji.com) when you meet any problems of using this demo. At a minimum please let us know:

* Which DJI Product you are using?
* Which iOS Device and iOS version you are using?
* A short description of your problem includes debug logs or screenshots.
* Any bugs or typos you come across.

## License

iOS-UILibraryDemo is available under the MIT license. Please see the LICENSE file for more info.