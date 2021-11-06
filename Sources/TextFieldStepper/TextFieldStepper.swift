import SwiftUI

// TODO: Refactor... Long press and validation
public struct TextFieldStepper: View {
    @Binding var doubleValue: Double {
        didSet {
            if doubleValue < config.minimum {
                doubleValue = config.minimum
            }

            if doubleValue > config.maximum {
                doubleValue = config.maximum
            }
            
            textValue = formatTextValue(doubleValue)
        }
    }
    
    @State private var keyboardOpened = false
    @State private var confirmEdit = false
    @State private var textValue: String = "0.0"
    
    let config: TextFieldStepperConfig
    
    public init(doubleValue: Binding<Double>, config: TextFieldStepperConfig = TextFieldStepperConfig()) {
        if doubleValue.wrappedValue > config.maximum || doubleValue.wrappedValue < config.minimum {
            fatalError("TextFieldStepper: Double value is out of bounds")
        }
        
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
            } else {
                LongPressButton(
                    doubleValue: $doubleValue,
                    config: config,
                    image: config.decrementImage,
                    action: decrease
                )
                .disabled(doubleValue <= config.minimum)
            }
            
            VStack {
                TextField("", text: $textValue) { editingChanged in
                    if editingChanged {
                        keyboardOpened = true
                        textValue = textValue.replacingOccurrences(of: config.unit, with: "")
                    } else {
                        keyboardOpened = false
                        
                        if !confirmEdit {
                            textValue = String(format: "%.1f", doubleValue) + "g"
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
            } else {
                LongPressButton(
                    doubleValue: $doubleValue,
                    config: config,
                    image: config.incrementImage,
                    action: increase
                )
                .disabled(doubleValue >= config.maximum)
            }
        }
        .padding()
        .onAppear {
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
        doubleValue = (doubleValue - config.increment) >= config.minimum ? doubleValue - config.increment : doubleValue
    }
    
    func increase() {
        doubleValue = (doubleValue + config.increment) <= config.maximum ? doubleValue + config.increment : doubleValue
    }
    
    func formatTextValue(_ value: Double) -> String {
        return String(format: "%.1f", value) + config.unit
    }

    func validateValue() {
        if textValue == "" || textValue == String(config.minimum) || Double(textValue) == nil || Double(textValue)! == config.minimum {
            // poorly formatted number, default to 0
            doubleValue = config.minimum
            //textValue = formatTextValue(config.minimum)
        } else if (Double(textValue)!  > config.maximum) {
            doubleValue = config.maximum
            //textValue = formatTextValue(config.maximum)
        } else if (Double(textValue)! < config.minimum) {
            doubleValue = config.minimum
//            textValue = formatTextValue(config.minimum)
        } else {
            // ALWAYS HITTING HERE
            
            print("HIt")
            doubleValue = Double(textValue) ?? config.minimum
        }
    }
}
