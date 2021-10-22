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


// TODO: Refactor... Long press and validation
public struct TextFieldStepper: View {
    @Binding var double: Double {
        didSet {
            textValue = formatTextValue(double)
        }
    }

    @State private var textValue: String = "0.0"
    @State private var keyboardOpened = false
    
    let label: String
    let measurement: String
    var minimum: Double
    var maximum: Double
    var increment: Double
    
    public init(double: Binding<Double>, label: String = "", measurement: String = "", minimum: Double = 0.0, maximum: Double = 100.0, increment: Double = 0.1) {
        self._double = double
        self.label = label
        self.measurement = measurement
        self.minimum = minimum
        self.maximum = maximum
        self.increment = increment
    }

    public var body: some View {
        HStack {
            LongPressButton(double: $double, image: "minus.circle.fill") {
                double = (double - increment) >= minimum ? double - increment : double
            }
            .disabled(double <= minimum || keyboardOpened)
            
            VStack {
                TextField("", text: $textValue) { editingChanged in
                    if editingChanged {
                        keyboardOpened = true
                        textValue = textValue.replacingOccurrences(of: measurement, with: "")
                    } else {
                        keyboardOpened = false
                        validateValue()
                    }
                }
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .black))
                .keyboardType(.decimalPad)
                
                if label != "" {
                    Text(label)
                    .font(.footnote)
                    .fontWeight(.light)
                }
            }
            
            LongPressButton(double: $double, image: "plus.circle.fill") {
                double = (double + increment) <= maximum ? double + increment : double
            }
            .disabled(double >= maximum || keyboardOpened)
        }
        .padding()
        .onAppear {
            textValue = formatTextValue(double)
        }
    }

    func formatTextValue(_ value: Double) -> String {
        return "\(String(format: "%g", value))\(measurement)"
    }

    func validateValue() {
        if textValue == "" || textValue == String(minimum) || Double(textValue) == nil || Double(textValue)! == minimum {
            // poorly formatted number, default to 0
            double = minimum
            textValue = formatTextValue(minimum)
        } else if (Double(textValue)!  > maximum) {
            double = maximum
            textValue = formatTextValue(maximum)
        } else {
            double = Double(textValue) ?? minimum
        }
    }
}

struct TextFieldStepper_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TextFieldStepper(double: .constant(50.0), label: "product", measurement: "g")
            TextFieldStepper(double: .constant(50.0))
        }
    }
}
