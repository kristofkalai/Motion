# Motion
Motion management never was so easy on iOS! 👋

## Setup

Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/stateman92/Motion", exact: .init(0, 0, 1))
```

[Or add the package in Xcode.](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

## Usage

```swift
let accelerometer = MotionManager.accelerometer // this object must be retained (store it in the class)

accelerometer
    .publisher
    .sink { data in
        // handle the data
    }
    .store(in: &cancellables)

// ...

MotionManager.accelerometer  // this object doesn't have to be retained, it's a Singleton
    .shared
    .publisher
    .sink { data in
        // handle the data
    }
    .store(in: &cancellables)
```

For details see the Example app.
