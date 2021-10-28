import SwiftUI

fileprivate struct CloseKeyboardGestures: ViewModifier {
    func body(content: Content) -> some View {
        // Close keyboard on tap
        content.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded({ gesture in
                // Close keyboard on swipe down
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
