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
    
    public init (
        label: String = "",
        unit: String = "",
        increment: Double = 0.1,
        minimum: Double = 0.0,
        maximum: Double = 100.0,
        interval: Double = 0.05,
        duration: Double = 0.25,
        decrementButton: TextFieldStepperButton = TextFieldStepperButton(image: Image(systemName: "minus.circle.fill"), color: Color.accentColor),
        incrementButton: TextFieldStepperButton = TextFieldStepperButton(image: Image(systemName: "plus.circle.fill"), color: Color.accentColor)
        
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
    }
}
