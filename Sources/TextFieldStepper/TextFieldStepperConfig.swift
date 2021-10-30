public struct TextFieldStepperConfig {
    let label: String
    let measurement: String
    let increment: Double
    let minimum: Double
    let maximum: Double
    let decrementImage: String
    let incrementImage: String
    
    public init(
        label: String = "Butter",
        measurement: String = "oz",
        increment: Double = 0.1,
        minimum: Double = 0.0,
        maximum: Double = 100.0,
        decrementImage: String = "minus.circle.fill",
        incrementImage: String = "plus.circle.fill"
    ) {
        self.label = label
        self.measurement = measurement
        self.increment = increment
        self.minimum = minimum
        self.maximum = maximum
        self.decrementImage = decrementImage
        self.incrementImage = incrementImage
    }
}
