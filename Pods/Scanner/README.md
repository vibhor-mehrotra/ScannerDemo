# Scanner


Scanner is a lightweight iOS app to extract text from an image. The project is a wrapper over iOS native Vision and AVFoundation frameworks.


## Features

- Asks user to click a photo of ID card or any document.
- Extract text from clicked image and provide summary to user.
- In case text is not found, relevant eror is shown to user and he is given the option to retry.


## Installation using Cocoapods

To integrate Scanner into your Xcode project using CocoaPods, specify it in your Podfile:

    pod 'Scanner', :git => 'https://github.com/vibhor-mehrotra/Scanner.git'


## Source Organisation

The project files are organised as follows:

     Scanner
        Image Capture
          -ImageScanner.swift
          -ImageRendererVC.swift
          -ImageRendererVC.xib
        Image Scanner
          -ImageRendererVM.swift
        -ScannerError
        -PublicUtility


## Architechture

I have used MVVM architechture for this project. ImageRendererVC/ImageRendererVM takes care of capturing the image using the interface provided by ImageRenderer.xib file.
Image is then scanned for texts in ImageScanner file which returns the list of texts found in image or error in case any.
ScannerError is custom Error created for the purpose of this project.

PublicUtility is the main file that is enough for anyone intending to use Scanner. It provides a class method to invoke SDK.


## Usage

To use the Scanner framework all you need to do is invoke the flow as mentioned below from the relevant view controller:

      Scanner.present(on: vc) {(output, error) in }

where output is Array of Strings and error is localisedDescription of error encountered in the process if any.

Mandatory: Please mention the usage description in Info.plist for the key NSCameraUsageDescription. 


## Requirements

- Xcode 12.0 or later
- macOS 10.15.5 or later
- iOS 13.0 or later


## Dependencies

No external dependencies required to run the project.


## Unit Tests

Scanner include a suite of unit tests within the test subdirectory. These tests can be run simply be executed the test action on the platform framework you would like to test.


## License

Scanner is released under the MIT license.
