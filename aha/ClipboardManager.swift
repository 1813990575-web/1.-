
import SwiftUI
import Combine

class ClipboardManager: ObservableObject {
    @Published var items: [PasteboardItem] = MockData.items



    func togglePin(for item: PasteboardItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPinned.toggle()
            sortItems()
        }
    }

    func deleteItem(_ item: PasteboardItem) {
        withAnimation {
            items.removeAll { $0.id == item.id }
        }
    }
    
    func updateItem(_ item: PasteboardItem, newContent: String, newRemark: String?) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].content = newContent
            items[index].remark = newRemark
            sortItems()
        }
    }
    
    func setTag(for item: PasteboardItem, tag: String?) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].tag = tag
        }
    }
    
    func removeTagFromAllItems(tag: String) {
        for index in items.indices {
            if items[index].tag == tag {
                items[index].tag = nil
            }
        }
    }
    
    func renameTagInAllItems(oldName: String, newName: String) {
        for index in items.indices {
            if items[index].tag == oldName {
                items[index].tag = newName
            }
        }
    }
    
    func addItem(content: String, remark: String?) {
        let newItem = PasteboardItem(content: content, timestamp: Date(), tag: nil, remark: remark)
        withAnimation {
            items.insert(newItem, at: 0)
            sortItems()
        }
    }
    
    func addItem(content: String, remark: String?, tag: String?) {
        let newItem = PasteboardItem(content: content, timestamp: Date(), tag: tag, remark: remark)
        withAnimation {
            items.insert(newItem, at: 0)
            sortItems()
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
    
    private func sortItems() {
        items.sort { item1, item2 in
            if item1.isPinned && !item2.isPinned {
                return true
            } else if !item1.isPinned && item2.isPinned {
                return false
            } else {
                return item1.timestamp > item2.timestamp
            }
        }
    }
}
