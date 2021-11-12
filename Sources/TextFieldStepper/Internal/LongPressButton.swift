import SwiftUI

struct LongPressButton: View {
    @Binding var doubleValue: Double
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    

    let config: TextFieldStepperConfig
    let image: TextFieldStepperImage
    let action: () -> Void
    
    var body: some View {
        Button(
            action: {
                !isLongPressing ? action() : invalidateLongPress()
            },
            label: {
                image
            }
        )
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
            (doubleValue > config.minimum && doubleValue < config.maximum) ? action() : invalidateLongPress()
        }
    }
}
