# TextFieldStepper
![gh](https://user-images.githubusercontent.com/8194147/145436007-1338579a-abc3-448c-b3f7-066daf6db306.gif)
A SwiftUI component to make inputting numbers easier than the native `Stepper` component. In addition to increment and decrement buttons, the user can tap the number to change it using the keyboard or long press one of the buttons to continue running the action until released.

# Platforms
Tested on iOS 16.0 but should work on both iOS and iPadOS 15 and up.

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

| Parameter            | Type                  | Default                                                                        | Note                                                                |
|----------------------|-----------------------|--------------------------------------------------------------------------------|---------------------------------------------------------------------|
| unit                 | String                | “”                                                                             | Unit to show after value.                                           |
| label                | String                | “”                                                                             | Label to show under value.                                          |
| increment            | Double                | 0.1                                                                            | How many points to increment or decrement                           |
| minimum              | Double                | 0.0                                                                            | Minimum accepted value.                                             |
| maximum              | Double                | 100.0                                                                          | Maximum accepted value.                                             |
| decrementImage       | TextFieldStepperImage | TextFieldStepperImage(systemName: "minus.circle.fill")                         | Image for decrement button.                                         |
| incrementImage       | TextFieldStepperImage | TextFieldStepperImage(systemName: "plus.circle.fill")                          | Image for increment button.                                         |
| declineImage         | TextFieldStepperImage | TextFieldStepperImage(systemName: “xmark.circle.fill”, color: Color.red)       | Image for decline button.                                           |
| confirmImage         | TextFieldStepperImage | TextFieldStepperImage(systemName: “checkmark.circle.fill”, color: Color.green) | Image for confirm button.                                           |
| disabledColor        | Color                 | Color(UIColor.lightGray)                                                       | Color of disabled button.                                           |
| labelOpacity         | Double                | 1.0                                                                            | Opacity of label under value.                                       |
| labelColor           | Color                 | .primary                                                                       | Color of label under value.                                         |
| valueColor           | Color                 | .primary                                                                       | Color of value.                                                     |
| shouldShowAlert      | Bool                  | true                                                                           | If alerts should show when a value is being defaulted due to error. |
| minimumDecimalPlaces | Int                   | 0                                                                              | Minimum decimal places to always show after the value.              |
| maximumDecimalPlaces | Int                   | 8                                                                              | Maximum decimal places to allow after value.                        |

# Styling
Below are the default colors and images that `TextFieldStepper` uses. In addition to this, when a button is disabled it will use `Color(UIColor.lightGray)` which can be overridden with the `disabledColor` parameter. You can also specify the label opacity and color with `labelOpacity` and `labelColor`. If you want to change the color of the main value, use `valueColor`.

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
    
# Keyboard Hiding
iOS poorly handles hiding the keyboard so `TextFieldStepper` includes a modifier named `.closeKeyboard(on: )` to make it better. You do not need to specify the `on` parameter and by default it will enable both swipe and tap gestures. If you only want to use one gesture you can provide either `.Tap` or `.Swipe`.

This modifier should be tied to a specific view in which you want interaction to occur, do not place it at the highest level of execution or things may not work as you intend.
    
# Floating point
The underlying value that `TextFieldStepper` expects is a `Double` which of course can sometimes cause floating-point issues. The component itself doesn’t ever modify the value however for validation checks it will be [`.rounded()`](https://developer.apple.com/documentation/swift/double/rounded(_:)) to 9 decimal places and then truncated to 8. This should not be an issue in nearly all situations but I just wanted to mention it for transparency sake. 

# License
MIT License

Copyright (c) 2022 Joe Scotto

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
