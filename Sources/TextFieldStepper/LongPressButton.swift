import SwiftUI

struct LongPressButton: View {
    @Binding var double: Double

    @State private var timer: Timer? = nil
    @State private var isLongPressing = false

    let image: String
    let config: TextFieldStepperConfig
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
            startTimer()
        })
        .buttonStyle(PlainButtonStyle())
    }

    func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
    
    func startTimer() {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { _ in
            // FIXME: Long press won't start on min or max.
            if (double > config.minimum && double < config.maximum) {
                action()
            } else {
                invalidateLongPress()
            }
        })
    }
}
