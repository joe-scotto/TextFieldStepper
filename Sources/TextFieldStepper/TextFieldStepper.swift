import SwiftUI

public struct TextFieldStepper: View {
    @Binding var doubleValue: Double
    
    @State private var keyboardOpened = false
    @State private var confirmEdit = false
    @State private var textValue = ""
    @State private var showAlert = false
    @State private var alert: Alert? = nil
    
    private let config: TextFieldStepperConfig
    
    private var cancelButton: some View {
        Button(action: {
            textValue = formatTextValue(doubleValue)
            closeKeyboard()
        }) {
            config.declineImage
        }
        .foregroundColor(config.declineImage.color)
    }
    
    private var confirmButton: some View {
        Button(action: {
            validateValue()
        }) {
            config.confirmImage
        }
        .foregroundColor(config.confirmImage.color)
    }
    
    private var decrementButton: some View {
        LongPressButton(
            doubleValue: $doubleValue,
            config: config,
            image: config.decrementImage,
            action: .decrement
        )
    }
    
    private var incrementButton: some View {
        LongPressButton(
            doubleValue: $doubleValue,
            config: config,
            image: config.incrementImage,
            action: .increment
        )
    }
    
    /**
     * init(doubleValue: Binding<Double>, unit: String, label: String, config: TextFieldStepperConfig)
     */
    public init(
        doubleValue: Binding<Double>,
        unit: String? = nil,
        label: String? = nil,
        config: TextFieldStepperConfig = TextFieldStepperConfig()
    ) {
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
            // Left button
            if keyboardOpened {
                cancelButton
            } else {
                decrementButton
            }
            
            VStack {
                TextField("", text: $textValue) { editingChanged in
                    if editingChanged {
                        // Keyboard opened, editing started
                        keyboardOpened = true
                        textValue = textValue.replacingOccurrences(of: config.unit, with: "")
                    } else {
                        if validateValue() {
                            keyboardOpened = false
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
            
            // Right button
            if keyboardOpened {
                confirmButton
            } else {
                incrementButton
            }
        }
        .onChange(of: doubleValue) { _ in
            // Should validate here also just as a double check
            
            textValue = formatTextValue(doubleValue)
        }
        .alert(isPresented: $showAlert) {
            alert!
        }
    }
            
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func formatTextValue(_ value: Double) -> String {
        String(format: "%g", value.decimal) + config.unit
    }
    
    func validateValue() -> Bool {
        // Reset alert status
        showAlert = false
        
        // Confirm doubleValue is actually a Double
        if let textToDouble = Double(textValue) {
            // 4. If doubleValue is less than config.minimum, throw Alert
            // 5. If doubleValue is greater than config.maximum, throw Alert
            if textToDouble.decimal < config.minimum {
                showAlert = true
                alert = Alert(
                    title: Text("Too small!"),
                    message: Text("\(config.label) must be at least \(formatTextValue(config.minimum)).")
                )
                
            }
            
            if textToDouble.decimal > config.maximum {
                showAlert = true
                alert = Alert(
                    title: Text("Too large!"),
                    message: Text("\(config.label) must be at most \(formatTextValue(config.maximum)).")
                )
            }
            
            // If all checks pass, set doubleValue
            if !showAlert {
                doubleValue = textToDouble
                closeKeyboard()
            }
        } else {
            // 2. If more than one decimal, throw Alert
            // 3. If contains characters, throw Alert (hardware keyboard issue)
            // 6. If doubleValue is empty, throw Alert
            showAlert = true
            alert = Alert(
                title: Text("Whoops!"),
                message: Text("\(config.label) must contain a valid number.")
            )
        }
        
        return !showAlert
    }
}
