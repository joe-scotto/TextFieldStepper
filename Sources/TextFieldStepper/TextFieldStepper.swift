import SwiftUI

// TODO: Refactor... Long press and validation
public struct TextFieldStepper: View {
    @Binding var doubleValue: Double {
        didSet {
            textValue = formatTextValue(doubleValue)
        }
    }
    
    @State private var textValue: String = "0.0"
    @State private var keyboardOpened = false
    
    let config: TextFieldStepperConfig
    
    public init(doubleValue: Binding<Double>, config: TextFieldStepperConfig = TextFieldStepperConfig()) {
        self._doubleValue = doubleValue
        self.config = config
    }
    
    public var body: some View {
        HStack {
            // Decrease
            LongPressButton(
                doubleValue: $doubleValue,
                config: config,
                button: config.decrementButton,
                action: decrease
            )
            .disabled(doubleValue <= config.minimum || keyboardOpened)
            
            VStack {
                TextField("", text: $textValue) { editingChanged in
                    if editingChanged {
                        keyboardOpened = true
                        textValue = textValue.replacingOccurrences(of: config.unit, with: "")
                    } else {
                        keyboardOpened = false
                        validateValue()
                    }
                }
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .black))
                .keyboardType(.decimalPad)
                
                if config.label != "" {
                    Text(config.label)
                        .font(.footnote)
                        .fontWeight(.light)
                }
            }
            
            // Increase
            LongPressButton(
                doubleValue: $doubleValue,
                config: config,
                button: config.incrementButton,
                action: increase
            )
            .disabled(doubleValue >= config.maximum || keyboardOpened)
        }
        .padding()
        .onAppear {
            if doubleValue < config.minimum {
                doubleValue = config.minimum
            }
            
            if doubleValue > config.maximum {
                doubleValue = config.maximum
            }
            
            textValue = formatTextValue(doubleValue)
        }
    }

    func decrease() {
        doubleValue = (doubleValue - config.increment) >= config.minimum ? doubleValue - config.increment : doubleValue
    }
    
    func increase() {
        doubleValue = (doubleValue + config.increment) <= config.maximum ? doubleValue + config.increment : doubleValue
    }
    
    func formatTextValue(_ value: Double) -> String {
        return String(format: "%g", value) + config.unit
    }

    func validateValue() {
        if textValue == "" || textValue == String(config.minimum) || Double(textValue) == nil || Double(textValue)! == config.minimum {
            // poorly formatted number, default to 0
            doubleValue = config.minimum
            textValue = formatTextValue(config.minimum)
        } else if (Double(textValue)!  > config.maximum) {
            doubleValue = config.maximum
            textValue = formatTextValue(config.maximum)
        } else if (Double(textValue)! < config.minimum) {
            doubleValue = config.minimum
            textValue = formatTextValue(config.minimum)
        } else {
            doubleValue = Double(textValue) ?? config.minimum
        }
    }
}
