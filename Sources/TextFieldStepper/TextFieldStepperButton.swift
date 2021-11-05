import SwiftUI

public struct TextFieldStepperButton {
    let image: Image
    let color: Color

    public init(image: Image, color: Color = Color.accentColor) {
        self.image = image
        self.color = color
    }
    
    public init(systemName: String, color: Color = Color.accentColor) {
        self.init(image: Image(systemName: systemName), color: color)
    }
    
    var body: some View {
        image.resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .frame(height: 35)
    }
}
