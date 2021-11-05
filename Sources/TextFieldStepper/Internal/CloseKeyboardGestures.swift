import SwiftUI

extension View {
    func closeKeyboardGesture() -> some View {
        self.onTapGesture {
            // Don't remove, needed to allow gesture.
        }.gesture(
            // Close keyboard on swipe down
            DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ gesture in
                if gesture.translation.height > 0 {
                    self.closeKeyboard()
                }
        }))
    }
    
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
