
import SwiftUI

struct ResizeHandle: View {
    @EnvironmentObject var panelSettings: PanelSettings
    @State private var startHeight: CGFloat?
    @State private var startLocation: CGFloat?

    var body: some View {
        HStack {
            Spacer()
            // 移除显眼的横线，使用透明视图
            Rectangle()
                .frame(width: 40, height: 5)
                .foregroundColor(.clear)
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .overlay(CursorArea())
        .gesture(dragGesture)
    }

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                if startHeight == nil {
                    startHeight = panelSettings.height
                    startLocation = value.location.y
                }
                guard let startHeight = startHeight, let startLocation = startLocation else { return }
                
                let offset = value.location.y - startLocation
                let newHeight = startHeight + offset
                
                // 设置最小/最大高度
                panelSettings.height = max(400, min(800, newHeight))
            }
            .onEnded { _ in
                startHeight = nil
                startLocation = nil
            }
    }
}

struct CursorArea: NSViewRepresentable {
    func makeNSView(context: Context) -> CursorView {
        CursorView()
    }
    
    func updateNSView(_ nsView: CursorView, context: Context) {}
}

class CursorView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        // 确保视图能够接收鼠标事件
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        NSCursor.resizeUpDown.set()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        NSCursor.arrow.set()
    }
    
    override func resetCursorRects() {
        super.resetCursorRects()
        addCursorRect(bounds, cursor: NSCursor.resizeUpDown)
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
}
