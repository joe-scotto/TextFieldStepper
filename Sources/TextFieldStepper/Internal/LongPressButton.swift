import SwiftUI

struct LongPressButton: View {
    @Binding var doubleValue: Double
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    
    enum Actions {
        case decrement,
             increment
    }
    
    let config: TextFieldStepperConfig
    let image: TextFieldStepperImage
    let action: Actions
    
    var body: some View {
        Button(action: {
            !isLongPressing ? updateDoubleValue() : invalidateLongPress()
        }) {
            image
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.25).onEnded(startTimer)
        )
        .foregroundColor(!disableButton() ? image.color : config.disabledColor)
        .disabled(disableButton())
    }
    
    /**
     * Stops the long press
     */
    private func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
    
    /**
     * Check if button should be enabled or not based on the action
     */
    private func disableButton() -> Bool {
        var shouldDisable = false
        
        switch action {
            case .decrement:
                shouldDisable = doubleValue.decimal <= config.minimum
            case .increment:
                shouldDisable = doubleValue.decimal >= config.maximum
        }
        
        return shouldDisable
    }
    
    /**
     * Starts the long press
     */
    private func startTimer(_ value: LongPressGesture.Value) {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            // Perform action regardless of actual value
            updateDoubleValue()
            
            // If value after action is outside of constraints, stop long press
            if doubleValue.decimal <= config.minimum || doubleValue.decimal >= config.maximum {
                invalidateLongPress()
            }
        }
    }
    
    /**
     * Decreases or increases the doubleValue
     */
    private func updateDoubleValue() {
        var newValue: Double
        
        switch action {
            case .decrement:
                newValue = doubleValue - config.increment
            case .increment:
                newValue = doubleValue + config.increment
        }
        
        doubleValue = (config.minimum...config.maximum).contains(newValue.decimal) ? newValue : doubleValue
    }
}
