
import SwiftUI

struct CardActionButtonStyle: ButtonStyle {
    @State private var isHovering = false
    var defaultColor: Color
    var hoverColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(6)
            .foregroundColor(isHovering ? hoverColor : defaultColor)
            .onHover { hovering in
                isHovering = hovering
            }
    }
}
