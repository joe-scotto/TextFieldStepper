import SwiftUI

extension View {
    public func closeKeyboard(on: CloseKeyboard.Gestures = .All) -> some View {
        modifier(CloseKeyboard(on: on))
    }
}
