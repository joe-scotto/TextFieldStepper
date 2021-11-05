import SwiftUI

struct LongPressButton: View {
    @Binding var doubleValue: Double

    @State private var timer: Timer? = nil
    @State private var isLongPressing = false

    let config: TextFieldStepperConfig
    let button: TextFieldStepperButton
    let action: () -> Void
    
    var body: some View {
        Button(
            action: {
                !isLongPressing ? action() : invalidateLongPress()
            },
            label: {
                button.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(button.color)
            }
        )
        .frame(height: 35)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: config.duration).onEnded(startTimer)
        )
    }
    
    private func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
    
    private func startTimer(_ value: LongPressGesture.Value) {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: config.interval, repeats: true) { _ in
            // FIXME: If 0.1 then minus button, overflows.
            if (doubleValue > config.minimum && doubleValue < config.maximum) {
                action()
            } else {
                invalidateLongPress()
            }
        }
    }
}
