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
                .foregroundColor(config.decrementImage.color)
                .disabled(doubleValue.decimal <= config.minimum)
            }
            
            VStack {
                TextField("", text: $textValue) { editingChanged in
                    if editingChanged {
                        keyboardOpened = true
                        textValue = textValue.replacingOccurrences(of: config.unit, with: "")
                    } else {
                        keyboardOpened = false
                        
                        if !confirmEdit {
                            textValue = String(format: "%.1f", Double(doubleValue)) + config.unit
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
//                .foregroundColor(config.incrementImage.color)
                .disabled(doubleValue.decimal >= config.maximum)
            }
        }
        .onChange(of: doubleValue) { _ in
            textValue = formatTextValue(doubleValue)
        }
    }
            
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func formatTextValue(_ value: Double) -> String {
        String(format: "%.2g", value.decimal) + config.unit
    }

    func validateValue() {
        // 1. Must be able to convert to double without unit
        // 2. Must be within and including minmum ... maximum
        // 3. Must not be empty, otherwise cancel
        
        
//        if textValue == "" || textValue == String(config.minimum) || Double(textValue) == nil || Double(textValue)! == config.minimum {
//            // poorly formatted number, default to 0
//            doubleValue = config.minimum
//            //textValue = formatTextValue(config.minimum)
//        } else if (Double(textValue)!  > config.maximum) {
//            doubleValue = config.maximum
//            //textValue = formatTextValue(config.maximum)
//        } else if (Double(textValue)! < config.minimum) {
//            doubleValue = config.minimum
////            textValue = formatTextValue(config.minimum)
//        } else {
//            // ALWAYS HITTING HERE
//            
//            print("HIt")
//            doubleValue = Double(textValue) ?? config.minimum
//        }
    }
}
