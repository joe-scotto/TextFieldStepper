import SwiftUI

// TODO: Refactor... Long press and validation
public struct TextFieldStepper: View {
    @Binding var doubleValue: Double {
        didSet {
            print("Non-rounded: \(doubleValue) - Rounded: \(doubleValue.decimal)")
            textValue = formatTextValue(doubleValue)
        }
    }
    
    @State private var keyboardOpened = false
    @State private var confirmEdit = false
    @State private var textValue: String = "0.0"
    
    let config: TextFieldStepperConfig
    
    /**
     * init(doubleValue: Binding<Double>, config: TextFieldStepperConfig)
     */
    public init(
        doubleValue: Binding<Double>,
        config: TextFieldStepperConfig = TextFieldStepperConfig()
    ) {
        self._doubleValue = doubleValue
        self.config = config
    }
    
    /**
     * init(doubleValue: Binding<Double>, unit: String, label: String, config: TextFieldStepperConfig)
     */
    public init(
        doubleValue: Binding<Double>,
        unit: String = "",
        label: String = "",
        config: TextFieldStepperConfig = TextFieldStepperConfig()
    ) {
        // Compose config
        var config = config
            config.unit = unit
            config.label = label
       
        self._doubleValue = doubleValue
        self.config = config
    }
    
    public var body: some View {
        HStack {
            if keyboardOpened {
                Button(action: {
                    confirmEdit = false
                    self.closeKeyboard()
                }, label: {
                    config.declineImage
                })
                .foregroundColor(config.declineImage.color)
            } else {
                LongPressButton(
                    doubleValue: $doubleValue,
                    config: config,
                    image: config.decrementImage,
                    action: decrease
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
                  }, label: {
                      config.confirmImage
                })
                    .foregroundColor(config.confirmImage.color)
            } else {
                LongPressButton(
                    doubleValue: $doubleValue,
                    config: config,
                    image: config.incrementImage,
                    action: increase
                )
//                .foregroundColor(config.incrementImage.color)
                    .disabled(doubleValue.decimal >= config.maximum)
            }
        }
        .padding()
        .onAppear {
            if !(config.minimum...config.maximum).contains(doubleValue.decimal) {
                fatalError("TextFieldStepper: Initial value not contained within constraints.")
            }
            
            textValue = formatTextValue(doubleValue)
        }
        .onTapGesture {
            // Don't remove, needed to allow gesture for some reason...
        }.gesture(
            // Close keyboard on swipe down
            DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ gesture in
                if gesture.translation.height > 0 {
                    confirmEdit = true
                    closeKeyboard()
                }
            })
        )
    }
            
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
            
    func decrease() {
//        print(doubleValue - config.increment)
        doubleValue = (doubleValue - config.increment).decimal >= config.minimum ? doubleValue - config.increment : doubleValue
    }
    
    func increase() {
//        print(doubleValue + config.increment)
        doubleValue = (doubleValue + config.increment).decimal <= config.maximum ? doubleValue + config.increment : doubleValue
    }
    
    func formatTextValue(_ value: Double) -> String {
        return String(format: "%.1f", value.decimal) + config.unit
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
