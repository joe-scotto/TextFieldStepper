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
            LongPressGesture(minimumDuration: 0.25).onEnded(startTimer)
        )
    }
    
    /**
     * Stops the long press
     */
    private func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
    
    /**
     * Starts the long press
     */
    private func startTimer(_ value: LongPressGesture.Value) {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            // Perform action regardless of actual value
            action()
            
            // If value after action is outside of constraints, stop long press
            if doubleValue.decimal <= config.minimum || doubleValue.decimal >= config.maximum {
                invalidateLongPress()
            }
        }
    }
}
