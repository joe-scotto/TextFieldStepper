# TextFieldStepper
![gh](https://user-images.githubusercontent.com/8194147/145436007-1338579a-abc3-448c-b3f7-066daf6db306.gif)
A SwiftUI component to make inputting numbers simpler than the native `Stepper` component. In addition to increment and decrement buttons, the user can tap the number to change it using the keyboard or long press one of the buttons to continue running the action until released.

# Platforms
Tested on iOS 15.0 but should work on both iOS and iPadOS 14 and up.

# Usage
Creating a `TextFieldStepper` is simple. 
``` swift
struct ContentView: View {
    @State private var butter = 0.0

    var body: some View {
        TextFieldStepper(
            doubleValue: $butter, 
            unit: "oz", 
            label: "Butter"
        )
    }
}
```

# Customizing
The defaults should be fine for most situations but there are certainly cases where they won't be. There are two methods that will allow you to change these [parameters](#parameters).

1. If you just want to modify a single component, you can directly pass in the parameter name and value.
    ``` swift
    struct ContentView: View {
        @State private var butter = 0.0

        var body: some View {
            TextFieldStepper(
                doubleValue: $butter, 
                unit: "oz", 
                label: "Butter",
                minimum: 5.0,
                maximum: 25.0
            )
        }
    }
    ```

2. If you want to modify multiple at once, use `TextFieldStepperConfig`. You can either pass a different one into each instance of the component or create a single one and make it available globally as a sort of default.
    ``` swift
    struct ContentView: View {
        @State private var butter = 0.0

        let config = TextFieldStepperConfig(
            unit: "oz",
            label: "Butter",
            minimum: 5.0,
            maximum: 25.0
        )

        var body: some View {
            TextFieldStepper(doubleValue: $butter, config: config)
        }
    }
    ```

# Parameters
Below are the parameters available on both `TextFieldStepper` and `TextFieldStepperConfig`.

| Parameter      | Type                  | Default                                                                        |
|----------------|-----------------------|--------------------------------------------------------------------------------|
| unit           | String                | “”                                                                             |
| label          | String                | “”                                                                             |
| increment      | Double                | 0.1                                                                            |
| minimum        | Double                | 0.0                                                                            |
| maximum        | Double                | 100.0                                                                          |
| decrementImage | TextFieldStepperImage | TextFieldStepperImage(systemName: "minus.circle.fill")                         |
| incrementImage | TextFieldStepperImage | TextFieldStepperImage(systemName: "plus.circle.fill")                          |
| declineImage   | TextFieldStepperImage | TextFieldStepperImage(systemName: “xmark.circle.fill”, color: Color.red)       |
| confirmImage   | TextFieldStepperImage | TextFieldStepperImage(systemName: “checkmark.circle.fill”, color: Color.green) |
| disabledColor  | Color                 | Color(UIColor.lightGray)                                                       |

# Styling
Below are the default colors and images that `TextFieldStepper` uses. In addition to this, when a button is disabled it will use `Color(UIColor.lightGray)` which can be overridden with the `disabledColor` parameter.

| Button          | Color                 | Image                 |
|-----------------|-----------------------|-----------------------|
| decrementButton | .accentColor          | minus.circle.fill     |
| incrementButton | .accentColor          | plus.circle.fill      | 
| declineButton   | .red                  | xmark.circle.fill     |
| confirmButtton  | .green                | checkmark.circle.fill |

You can override the default images by creating an instance of `TextFieldStepperImage` and passing that to the corresponding parameter on either `TextFieldStepper` or `TextFieldStepperConfig`. There are two methods of instantiating `TextFieldStepperImage`. Currently there is no method to just change the color, you must provide an image as well.

1. If you’re just using a system named image, you can use the `systemName` parameter. 
    ``` swift 
    let image = TextFieldStepperImage(systemName: "circle.fill")
    ```
    
2. If you're using a custom image, directly pass an `Image`.
    ``` swift 
    let image = TextFieldStepperImage(image: Image(systemName: "circle.fill")
    ```
    
# Floating point
The underlying value that `TextFieldStepper` expects is a `Double` which of course can sometimes cause floating-point issues. The component itself doesn’t ever modify the value however for validation checks it will be rounded to 8 decimal places. This should not be an issue in nearly all situations but I just wanted to mention it for transparency sake. 

# License
MIT License

Copyright (c) 2021 Joe Scotto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
