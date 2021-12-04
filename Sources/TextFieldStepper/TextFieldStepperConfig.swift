import SwiftUI

public struct TextFieldStepperConfig {
    var label: String
    var unit: String
    let increment: Double
    let minimum: Double
    let maximum: Double
    let decrementImage: TextFieldStepperImage
    let incrementImage: TextFieldStepperImage
    let declineImage: TextFieldStepperImage
    let confirmImage: TextFieldStepperImage
    let disabledColor: Color

    public init (
        label: String = "",
        unit: String = "",
        increment: Double = 0.1,
        minimum: Double = 0.0,
        maximum: Double = 100.0,
        decrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "minus.circle.fill"),
        incrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "plus.circle.fill"),
        declineImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "xmark.circle.fill", color: Color.red),
        confirmImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "checkmark.circle.fill", color: Color.green),
        disabledColor: Color = Color(UIColor.lightGray)
    ) {
        self.label = label
        self.unit = unit
        self.increment = increment
        self.minimum = minimum
        self.maximum = maximum
        self.decrementImage = decrementImage
        self.incrementImage = incrementImage
        self.declineImage = declineImage
        self.confirmImage = confirmImage
        self.disabledColor = disabledColor
    }
}
