# TextFieldStepper
Essentially a custom implementation of the built-in SwiftUI `Stepper` component. Unlike it's counterpart, the value of a `TextFieldStepper` component can be changed using either the on-screen buttons or the keyboard. The component also implements a long press action where if you hold the button longer than 0.25 seconds, it will continue incrementing or decrementing until you release.

# Platforms
- iOS (14.0+)
- iPadOS (14.0+)

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

# Custom Configuration
The default parameters should be fine for most situations but there are certainly cases where they won't be. There are two methods, that will allow you to change some of these parameters.

1. If you just want to modify a single component, you can simply pass in a `TextFieldStepperConfig` when creating it. You can see a full list of available configuration parameters in [TextFieldStepperConfig.swift](https://github.com/joe-scotto/TextFieldStepper/blob/main/Sources/TextFieldStepper/TextFieldStepperConfig.swift).
    
    ``` swift
    struct ContentView: View {
        @State private var butter = 0.0
        
        let config = TextFieldStepperConfig(
            unit: "oz",
            label: "Butter"
        )

        var body: some View {
            TextFieldStepper(doubleValue: $butter, config: config)
        }
    }
    ```
2. If you want to modify the default way in which every instance of `TextFieldStepper` is created, fork this repository and modify the configuration within [TextFieldStepperConfig.swift](https://github.com/joe-scotto/TextFieldStepper/blob/main/Sources/TextFieldStepper/TextFieldStepperConfig.swift).

# Defaults
`TextFieldStepper` will utilize the applications `accentColor`, `Color.red`, and `Color.green for the buttons. This can of course be overridden with `TextFieldStepperConfig`.

# Floating point
`TextFieldStepper` uses `Double` which of course can sometimes cause issues in regards to floating-point. The component itself does not ever modify the actual value that is passed through however for comparison checks on the minimum and maximum value, the double will be rounded to 8 decimal places. This shouldn't be an issue but I just wanted to mention it in case something comes up.

