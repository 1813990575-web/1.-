
import SwiftUI

struct ContentView: View {
    @StateObject private var clipboardManager = ClipboardManager()
    @StateObject private var panelSettings = PanelSettings()
    @StateObject private var tagManager = TagManager()
    @State private var selectedCategory: CategoryType = .all
    @State private var searchText: String = ""
    @State private var showToast: Bool = false

    var filteredItems: [PasteboardItem] {
        var result = clipboardManager.items

        switch selectedCategory {
        case .all:
            break
        case .custom(let tag):
            result = result.filter { $0.tag == tag }
        }

        if !searchText.isEmpty {
            result = result.filter { 
                $0.content.localizedCaseInsensitiveContains(searchText) || 
                ($0.remark ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var currentTag: String? {
        if case .custom(let tag) = selectedCategory {
            return tag
        }
        return nil
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(searchText: $searchText)
                .padding(.top)

            CategoryBarView(selectedCategory: $selectedCategory)
                .padding(.vertical, 10)

            CardListView(items: filteredItems, showToast: $showToast)

            // L4: 输入/功能区 & Resize Handle
            VStack(spacing: 0) {
                FooterView(
                    currentTag: currentTag,
                    onCommit: { content, remark, tag in
                        clipboardManager.addItem(content: content, remark: remark, tag: tag)
                    }
                )
                ResizeHandle()
            }
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .environmentObject(clipboardManager)
        .environmentObject(panelSettings)
        .environmentObject(tagManager)
        .frame(width: 400, height: panelSettings.height)
        .background(VisualEffectView())
        .cornerRadius(16)
        .overlay(
            VStack {
                Spacer()
                ToastView(message: "已复制")
                    .opacity(showToast ? 1 : 0)
                    .animation(nil, value: showToast)
                Spacer().frame(height: 60)
            }
        )
    }
}

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .popover
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
