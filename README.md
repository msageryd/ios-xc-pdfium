# Pdfium
![Platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![Apple Silicon compatible](https://img.shields.io/badge/Apple%20Silicon-compatible-green.svg)
![CocoaPods compatible](https://img.shields.io/badge/CocoaPods-compatible-green.svg)
![SPM compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-green.svg)<br/>
![Catalyst compatible](https://img.shields.io/badge/Catalyst-incompatible-red.svg)

---

## About this fork

This fork exists to fix a single packaging bug in upstream
[TechTeamer/ios-xc-pdfium](https://github.com/TechTeamer/ios-xc-pdfium)
v1.3.0: the arm64 sub-slice inside the `ios-arm64_x86_64-simulator` variant
is labeled `platform IOS` (device) instead of `platform IOSSIMULATOR`.
On Apple Silicon Macs this causes Xcode to refuse to link when building
for the iOS Simulator, with:

> Building for 'iOS-simulator', but linking in dylib built for 'iOS'

**What changed vs upstream v1.3.0:** the arm64 sub-slice's
`LC_BUILD_VERSION` platform marker was rewritten to `IOSSIMULATOR` via
`vtool -set-build-version iossim`, the framework was re-ad-hoc-signed,
and the zip + `Package.swift` URL/checksum were updated to reference
this repo. The device slice and all C/C++ binary content are unchanged.
Ad-hoc signing is fine for simulator (which doesn't verify strict
provenance); device consumers still use the upstream-unchanged device
slice.

**Use via Swift Package Manager:**

```
https://github.com/msageryd/ios-xc-pdfium
```

Pin by revision (reproducible, no drift on future pushes):

```
28d0e27d16e58a0feead4195bd713fb4983db726
```

**Scope:** this fork tracks upstream v1.3.0 plus the platform-marker fix.
It is **not** a general PDFium update track. When upstream ships a
release with the build-pipeline fix, switch back to upstream. If
upstream ships new PDFium versions without fixing the packaging bug,
this fork may rebase forward — watch the commit log.

**Upstream issue:** filed at TechTeamer/ios-xc-pdfium with a proposed
build-pipeline fix (wrong SDK targeted for the arm64 simulator binary).

---

## Release

### 1.3.0
Build date: 2024-03-18 12:08

### 1.2.0
Build date: 2023-12-04 10:40

### 1.1.0
Build date: 2023-07-28 14:26

### 1.0.0
Build date: 2022-11-09 00:03


## Minimum runtime requirements
iOS 15+


## Installation
### Swift Package Manager
In your Xcode project go to: File -> Swift Packages -> Add Package Dependency<br/>
https://github.com/TechTeamer/ios-xc-pdfium.git


### Cocoapods
Just copy into your podfile, looks like this.<br/>

<br/>------------------------ Podfile ------------------------

source 'https://github.com/CocoaPods/Specs.git'<br/>
source 'https://github.com/TechTeamer/ios-xc-pdfium.git'

  use_frameworks!<br/>
  target 'YourApp' do<br/>
    pod 'Pdfium'<br/>
  end
  
<br/>---------------------------------------------------------

run:<br/>
pod repo update<br/>
pod install<br/>

## Description
This is a new generation xcframework is built for Apple machines including iOS/iPadOS/Simulators(arm64 & x86_64).

We are using the bblanchon's builder scripts for building, but we extended it with ios-simulator for arm64 and x86_64 resolved the simulator build issues. 

You can find the release commits here:
https://pdfium.googlesource.com/pdfium

You can find the official source here:
https://pdfium.googlesource.com/pdfium/+/refs/heads/main

