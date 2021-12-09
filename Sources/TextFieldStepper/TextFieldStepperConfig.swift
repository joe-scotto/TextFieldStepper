import SwiftUI

public struct TextFieldStepperConfig {
    var unit: String
    var label: String
    var increment: Double
    var minimum: Double
    var maximum: Double
    var decrementImage: TextFieldStepperImage
    var incrementImage: TextFieldStepperImage
    var declineImage: TextFieldStepperImage
    var confirmImage: TextFieldStepperImage
    var disabledColor: Color

    public init (
        unit: String = "",
        label: String = "",
        increment: Double = 0.1,
        minimum: Double = 0.0,
        maximum: Double = 100.0,
        decrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "minus.circle.fill"),
        incrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "plus.circle.fill"),
        declineImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "xmark.circle.fill", color: Color.red),
        confirmImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "checkmark.circle.fill", color: Color.green),
        disabledColor: Color = Color(UIColor.lightGray)
    ) {
        self.unit = unit
        self.label = label
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
