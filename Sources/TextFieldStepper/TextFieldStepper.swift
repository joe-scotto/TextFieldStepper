import SwiftUI

public struct TextFieldStepper: View {
    @Binding var doubleValue: Double
    
    @State private var keyboardOpened = false
    @State private var confirmEdit = false
    @State private var textValue: String = "0.0"
    
    private let config: TextFieldStepperConfig
    
    /**
     * init(doubleValue: Binding<Double>, unit: String, label: String, config: TextFieldStepperConfig)
     */
    public init(
        doubleValue: Binding<Double>,
        unit: String? = nil,
        label: String? = nil,
        config: TextFieldStepperConfig = TextFieldStepperConfig()
    ) {
        // Confirm constraints
        if !(config.minimum...config.maximum).contains(doubleValue.wrappedValue.decimal) {
            fatalError("TextFieldStepper: Initial value outside of constraints.")
        }
        
        // Compose config
        var config = config
            config.unit = unit ?? config.unit
            config.label = label ?? config.label
       
        // Assign properties
        self._doubleValue = doubleValue
        self.config = config
        
        // Set text value with State
        _textValue = State(initialValue: formatTextValue(doubleValue.wrappedValue))
    }
    
    public var body: some View {
        HStack {
            if keyboardOpened {
                Button(action: {
                    confirmEdit = false
                    self.closeKeyboard()
                }) {
                    config.declineImage
                }
                .foregroundColor(config.declineImage.color)
            } else {
                LongPressButton(
                    doubleValue: $doubleValue,
                    config: config,
                    image: config.decrementImage,
                    action: .decrement
                )
            }
            
            VStack {
                TextField("", text: $textValue) { editingChanged in
                    if editingChanged {
                        // Keyboard opened, editing started
                        keyboardOpened = true
                        textValue = textValue.replacingOccurrences(of: config.unit, with: "")
                    } else {
                        keyboardOpened = false
                        
                        // Check which button was pressed
                        if !confirmEdit {
                            textValue = formatTextValue(doubleValue)
                        } else {
                            validateValue()
                        }
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
            
            if keyboardOpened {
                Button(action: {
                    confirmEdit = true
                    self.closeKeyboard()
                }) {
                    config.confirmImage
                }
                .foregroundColor(config.confirmImage.color)
            } else {
                LongPressButton(
                    doubleValue: $doubleValue,
                    config: config,
                    image: config.incrementImage,
                    action: .increment
                )
            }
        }
        .onChange(of: doubleValue) { _ in
            
            // Min and max characters
            textValue = formatTextValue(doubleValue)
        }
    }
            
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func formatTextValue(_ value: Double) -> String {
        String(format: "%g", value.decimal) + config.unit
    }
    
    func setToMaximum() {
        doubleValue = config.maximum
        textValue = formatTextValue(config.maximum)
    }

    func setToMinimum() {
        doubleValue = config.minimum
        textValue = formatTextValue(config.minimum)
    }
    
    func validateValue() {
        if textValue.isEmpty {
            setToMinimum()
            return
        }
        
        if let textToDouble = Double(textValue) {
            if textToDouble.decimal < config.minimum {
                setToMinimum()
                return
            }
            
            if textToDouble.decimal > config.maximum {
                setToMaximum()
                return
            }
            
            doubleValue = textToDouble
        }
    }
}
