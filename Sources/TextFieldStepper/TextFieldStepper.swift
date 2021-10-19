import SwiftUI

fileprivate struct LongPressButton: View {
    @Binding var double: Double

    @State private var timer: Timer? = nil
    @State private var isLongPressing = false

    private let image: String
    private let action: () -> Void

    init(image: String, double: Binding<Double>, action: @escaping () -> Void) {
        self.image = image
        self._double = double
        self.action = action
    }

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
            value = formatTextValue(double)
        }
    }

    @State private var value: String = "10.0"
    @State private var keyboardOpened = false
    
    let label: String
    let measurement: String
    
    public init(double: Binding<Double>, label: String, measurement: String) {
        self._double = double
        self.label = label
        self.measurement = measurement
    }

    public var body: some View {
        HStack {
            LongPressButton(image: "minus.circle.fill", double: $double) {
                double = (double - 0.1) >= 0.0 ? double - 0.1 : double
            }
            .disabled(double <= 0 || keyboardOpened)
            
            VStack {
                TextField("", text: $value) { editingChanged in
                    if editingChanged {
                        keyboardOpened = true
                        value = value.replacingOccurrences(of: measurement, with: "")
                    } else {
                        keyboardOpened = false
                        validateValue()
                    }
                }
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .black))
                .keyboardType(.decimalPad)
                
                Text(label)
                    .font(.footnote)
                    .fontWeight(.light)
            }
            
            LongPressButton(image: "plus.circle.fill", double: $double) {
                double = (double + 0.1) <= 100.0 ? double + 0.1 : double
            }
            .disabled(double >= 100 || keyboardOpened)
        }
        .padding()
        .onAppear {
            value = formatTextValue(double)
        }
    }

    func formatTextValue(_ value: Double) -> String {
        return "\(String(format: "%g", value))\(measurement)"
    }

    func validateValue() {
        if value == "" || value == "0.0" || Double(value) == nil || Double(value)! == 0 {
            // poorly formatted number, default to 1mm
            double = 0
            value = formatTextValue(0)
        } else if (Double(value)!  > 100) {
            double = 100
            value = formatTextValue(100)
        } else {
            double = Double(value) ?? 0
        }
    }
}

struct FocalLengthStepper_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldStepper(double: .constant(50.0), label: "product", measurement: "g")
    }
}
