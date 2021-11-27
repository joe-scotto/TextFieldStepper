import SwiftUI

public struct TextFieldStepper: View {
    @Binding var doubleValue: Double
    
    @State private var keyboardOpened = false
    @State private var confirmEdit = false
    @State private var textValue = ""
    @State private var showAlert = false
    
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
//        if !(config.minimum...config.maximum).contains(doubleValue.wrappedValue.decimal) {
//            fatalError("TextFieldStepper: Initial value outside of constraints.")
//        }
        
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
                            // Declined to save, keep old value
                            textValue = formatTextValue(doubleValue)
                        } else {
                            // Saved, format value
                            validateValue()
                        }
                    }
                }
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .black))
                .keyboardType(.decimalPad)
                
                if !config.label.isEmpty {
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
            textValue = formatTextValue(doubleValue)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Input issue"),
                message: Text("Please input a valid number")
            )
        }
    }
            
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func formatTextValue(_ value: Double) -> String {
        String(format: "%g", value.decimal) + config.unit
    }
    
    func validateValue() {
        /**
         * - Keyboard should remain open until error has been resolved or user cancels
         * - Alert message and title changes based on the error
         * - doubleValue is only updated when all error conditions are satisfied
         *
         * 1. Cut decimal after 8 places automatically
         * 2. If more than one decimal, throw Alert
         * 3. If contains characters, throw Alert (hardware keyboard issue)
         * 4. If doubleValue is less than config.minimum, throw Alert
         * 5. If doubleValue is greater than config.maximum, throw Alert
         * 6. If doubleValue is empty, throw Alert
         */
        
        if var textToDouble = Double(textValue) {
            if textToDouble.decimal < config.minimum {
//                showAlert = true
            }
            
            if textToDouble.decimal > config.maximum {
//                textToDouble = config.maximum
//                showAlert = true
            }
            
            doubleValue = textToDouble
        } else {
            doubleValue = config.minimum
        }
    }
}
