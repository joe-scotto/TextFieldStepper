
# TextFieldStepper - WORK IN PROGRESS, BY NO MEANS PRODUCTION READY!

A custom number input component with both buttons and text input. Essentially is a custom implementation of the built-in `Stepper()` view. Also includes long press gestures for quickly incrementing or decrementing. 


# Platforms
- iOS 13.0+
- iPadOS 13.0+

# Usage
```
TextFieldStepper(double: Binding<Double>), label: String, measurement: String)
```

# Custom Configuration
If you wish to set different default values for each component, you have two options.

1. Pass a custom configuration to each component
    - For most, this will be the preferable option as each component will most likely be different within your application. However, there are times where you will want all of them to be the same but might not want to pass a configuration to each one... skip to option 2 if this is your case.


# Keyboard issues....
Keyboards are absolutely obnoxious in Swift... as of now, when the keyboard opens the user can either tap out or swipe down to dismiss it. The issue with this though is that any tap will still close the keyboard. I hope to implement a better method for this in version 2.1.0+ or 3.0.0+ something with a toolbar
