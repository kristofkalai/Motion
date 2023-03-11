# Motion
Motion management never was so easy on iOS! 👋

### How to use

You can use the manager like so:

```swift
MotionManager.accelerometer
    .shared
    .publisher
    .sink { data in
        // handle the data
    }
    .store(in: &cancellables)
```

For details see the Example app.
