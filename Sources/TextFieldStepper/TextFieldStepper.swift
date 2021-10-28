import SwiftUI

fileprivate struct LongPressButton: View {
    @Binding var double: Double

    @State private var timer: Timer? = nil
    @State private var isLongPressing = false

    let image: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            if (isLongPressing) {
               invalidateLongPress()
            } else {
                action()
            }
        }, label: {
            Image(systemName: image).resizable().aspectRatio(contentMode: .fit)
        })
        .frame(height: 35)
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.25).onEnded { _ in
                isLongPressing = true
                timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { _ in
                    // FIXME: Long press won't start on min or max.
                    if (double > 0 && double < 100) {
                        action()
                    } else {
                        invalidateLongPress()
                    }
                })
        })
        .buttonStyle(PlainButtonStyle())
    }

    func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
}

public class TextFieldStepperConfig: ObservableObject {
    let label: String
    let measurement: String
    let increment: Double
    let minimum: Double
    let maximum: Double
    
    public init(label: String = "Product", measurement: String = "g", increment: Double = 0.1, minimum: Double = 0.0, maximum: Double = 100.0) {
        self.label = label
        self.measurement = measurement
        self.increment = increment
        self.minimum = minimum
        self.maximum = maximum
    }
}

fileprivate extension View {
    func thiccText() -> some View {
        self.multilineTextAlignment(.center)
            .font(.system(size: 24, weight: .black))
            .keyboardType(.decimalPad)
    }
}

fileprivate extension Text {
    func notSoThiccText() -> Text {
        self
            .font(.footnote)
            .fontWeight(.light)
    }
}


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
    
    public init(doubleValue: Binding<Double>, config: TextFieldStepperConfig? = nil) {
        self._doubleValue = doubleValue
        self.config = config ?? TextFieldStepperConfig()
    }
    
    public var body: some View {
        HStack {
            LongPressButton(double: $doubleValue, image: "minus.circle.fill") {
                doubleValue = (doubleValue - config.increment) >= config.minimum ? doubleValue - config.increment : doubleValue
            }
            .disabled(doubleValue <= config.minimum || keyboardOpened)
            
            VStack {
                TextField("", text: $textValue) { editingChanged in
                    if editingChanged {
                        keyboardOpened = true
                        textValue = textValue.replacingOccurrences(of: config.measurement, with: "")
                    } else {
                        keyboardOpened = false
                        validateValue()
                    }
                }
                .thiccText()
                
                if config.label != "" {
                    Text(config.label)
                        .notSoThiccText()
                }
            }
            
            LongPressButton(double: $doubleValue, image: "plus.circle.fill") {
                doubleValue = (doubleValue + config.increment) <= config.maximum ? doubleValue + config.increment : doubleValue
            }
            .disabled(doubleValue >= config.maximum || keyboardOpened)
        }
        .padding()
        .onAppear {
            textValue = formatTextValue(doubleValue)
        }
    }

    func formatTextValue(_ value: Double) -> String {
        return "\(String(format: "%g", value))\(config.measurement)"
    }

    func validateValue() {
        if textValue == "" || textValue == String(config.minimum) || Double(textValue) == nil || Double(textValue)! == config.minimum {
            // poorly formatted number, default to 0
            doubleValue = config.minimum
            textValue = formatTextValue(config.minimum)
        } else if (Double(textValue)!  > config.maximum) {
            doubleValue = config.maximum
            textValue = formatTextValue(config.maximum)
        } else {
            doubleValue = Double(textValue) ?? config.minimum
        }
    }
}

struct TextFieldStepper_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldStepper(doubleValue: .constant(50.0))
        }
    }
}
