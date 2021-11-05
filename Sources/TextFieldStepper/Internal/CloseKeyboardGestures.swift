import SwiftUI

fileprivate struct CloseKeyboardGesture: ViewModifier {
    func body(content: Content) -> some View {
        // Close keyboard on tap
        content.gesture(
            // Close keyboard on swipe down
            DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ gesture in
                if gesture.translation.height > 0 {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }))
    }
}

public extension View {
    func closeKeyboardGesture() -> some View {
        modifier(CloseKeyboardGesture())
    }
}
