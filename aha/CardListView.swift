
import SwiftUI

struct CardListView: View {
    @EnvironmentObject var clipboardManager: ClipboardManager
    let items: [PasteboardItem]
    @Binding var showToast: Bool
    @State private var draggingItem: PasteboardItem?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    CardView(item: item, showToast: $showToast)
                        .scaleEffect(draggingItem?.id == item.id ? 1.05 : 1.0)
                        .opacity(draggingItem?.id == item.id ? 0.8 : 1.0)
                        .shadow(
                            color: draggingItem?.id == item.id ? Color.black.opacity(0.2) : Color.clear,
                            radius: draggingItem?.id == item.id ? 10 : 0
                        )
                        .animation(.easeInOut(duration: 0.2), value: draggingItem?.id)
                        .id(item.id)
                        .onDrag {
                            draggingItem = item
                            return NSItemProvider(object: item.id.uuidString as NSString)
                        }
                        .onDrop(of: [.text], delegate: CardDropDelegate(
                            item: item,
                            items: items,
                            draggingItem: $draggingItem,
                            onMove: { source, destination in
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    clipboardManager.moveItem(from: source, to: destination)
                                }
                            }
                        ))
                }
            }
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.3), value: items.map { $0.id })
        }
    }
}

struct CardDropDelegate: DropDelegate {
    let item: PasteboardItem
    let items: [PasteboardItem]
    @Binding var draggingItem: PasteboardItem?
    let onMove: (IndexSet, Int) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        withAnimation(.easeInOut(duration: 0.2)) {
            draggingItem = nil
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggingItem = draggingItem,
              draggingItem.id != item.id,
              let fromIndex = items.firstIndex(where: { $0.id == draggingItem.id }),
              let toIndex = items.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        
        if fromIndex < toIndex {
            onMove(IndexSet(integer: fromIndex), toIndex + 1)
        } else {
            onMove(IndexSet(integer: fromIndex), toIndex)
        }
    }
}
