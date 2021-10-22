import SwiftUI

struct CloseKeyboardGestures: ViewModifier {
    func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .gesture(
            // Swipe down gesture
            DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ gesture in
                if gesture.translation.height > 0 {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }))
    }
}
public extension View {
    func closeKeyboardGestures() -> some View {
        modifier(CloseKeyboardGestures())
    }
}
