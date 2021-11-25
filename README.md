
# TextFieldStepper
A custom number component with both buttons and keyboard input. Essentially a custom implementation of the built-in `Stepper()` component. You can optionally long press the decrement or increment buttons to continue adding or decreasing until released.  

# Platforms
- iOS 14.0+
- iPadOS 14.0+

# Usage
TextFieldStepper(
    double: Binding<Double>), 
    config: TextFieldStepperConfig? = TextFieldStepperConfig()
)

# Custom Configuration
Sometimes you may want to use a different configuration than what is default, there are two methods of doing this depending on your application.
1. Directly pass in a configuration object when creating an instance of the `TextFieldStepper`
    1.
    ```
    let config = TextFieldStepperConfig(
        label: String = "",
        unit: String = "",
        increment: Double = 0.1,
        minimum: Double = 0.0,
        maximum: Double = 100.0,
        interval: Double = 0.05,
        duration: Double = 0.25,
        decrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "minus.circle.fill"),
        incrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "plus.circle.fill"),
        declineImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "xmark.circle.fill", color: Color.red),
        confirmImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "checkmark.circle.fill", color: Color.green),
        disabledColor: Color = Color(UIColor.lightGray)
    )
    ```
2. Fork the repository and modify the `TextFieldStepperConfig.swift` file. This is useful if you want to completely change how the default `TextFieldStepper()` is created. 

# Floating point
The data type that is used for TextFieldStepper is a `Double`. The value itself is never modified when passed through but the comparison value for the `config.minimum` and `config.maximum` is rounded to 8 decimal places. This is to prevent issues with floating point values such as repeating decimals and unexpected comparisons. I have tested most scenarios and you shouldn't have to worry about this but if you encounter an issue where the decrement or increment button is not disabling when you expect it to, floating point is probably to blame. I just wanted to put this out there as a bit of a warning in case something does come up.


# Notes for final README.md
1. Accent color is used by default for the button color, red/green for confirm text input. Can be overridden with `TextFieldStepperImage()`
