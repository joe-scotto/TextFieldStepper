import SwiftUI

public struct TextFieldStepperConfig {
    let label: String
    let unit: String
    let increment: Double
    let minimum: Double
    let maximum: Double
    let interval: Double
    let duration: Double
    let decrementButton: TextFieldStepperButton
    let incrementButton: TextFieldStepperButton
    let declineButton: TextFieldStepperButton
    let confirmButton: TextFieldStepperButton

    public init (
        label: String = "",
        unit: String = "",
        increment: Double = 0.1,
        minimum: Double = 0.0,
        maximum: Double = 100.0,
        interval: Double = 0.05,
        duration: Double = 0.25,
        decrementButton: TextFieldStepperButton = TextFieldStepperButton(systemName: "minus.circle.fill"),
        incrementButton: TextFieldStepperButton = TextFieldStepperButton(systemName: "plus.circle.fill"),
        declineButton: TextFieldStepperButton = TextFieldStepperButton(systemName: "xmark.circle.fill", color: Color.red),
        confirmButton: TextFieldStepperButton = TextFieldStepperButton(systemName: "checkmark.circle.fill", color: Color.green)

    ) {
        self.label = label
        self.unit = unit
        self.increment = increment
        self.minimum = minimum
        self.maximum = maximum
        self.interval = interval
        self.duration = duration
        self.decrementButton = decrementButton
        self.incrementButton = incrementButton
        self.declineButton = declineButton
        self.confirmButton = confirmButton
    }
}
