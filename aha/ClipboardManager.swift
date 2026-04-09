
import SwiftUI
import Combine
import CoreData

class ClipboardManager: ObservableObject {
    @Published var items: [PasteboardItem] = []
    private let persistence = PersistenceController.shared

    init() {
        loadItems()
    }

    private func loadItems() {
        let entities = persistence.fetchPasteboardItems()
        items = entities.map { PasteboardItem(entity: $0) }
        sortItems()
    }

    private func saveItems() {
        // 这里我们不需要手动保存，因为每个操作都会直接更新数据库
    }

    func togglePin(for item: PasteboardItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPinned.toggle()
            sortItems()
            // 更新数据库
            let entities = persistence.fetchPasteboardItems()
            if let entity = entities.first(where: { $0.id == item.id }) {
                persistence.updatePasteboardItem(entity, content: nil, timestamp: nil, tag: nil, remark: nil, isPinned: items[index].isPinned)
            }
        }
    }

    func deleteItem(_ item: PasteboardItem) {
        withAnimation {
            items.removeAll { $0.id == item.id }
        }
        // 从数据库删除
        let entities = persistence.fetchPasteboardItems()
        if let entity = entities.first(where: { $0.id == item.id }) {
            persistence.deletePasteboardItem(entity)
        }
    }
    
    func updateItem(_ item: PasteboardItem, newContent: String, newRemark: String?) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].content = newContent
            items[index].remark = newRemark
            sortItems()
            // 更新数据库
            let entities = persistence.fetchPasteboardItems()
            if let entity = entities.first(where: { $0.id == item.id }) {
                persistence.updatePasteboardItem(entity, content: newContent, timestamp: nil, tag: nil, remark: newRemark, isPinned: nil)
            }
        }
    }
    
    func setTag(for item: PasteboardItem, tag: String?) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].tag = tag
            // 更新数据库
            let entities = persistence.fetchPasteboardItems()
            if let entity = entities.first(where: { $0.id == item.id }) {
                persistence.updatePasteboardItem(entity, content: nil, timestamp: nil, tag: tag, remark: nil, isPinned: nil)
            }
        }
    }
    
    func removeTagFromAllItems(tag: String) {
        for index in items.indices {
            if items[index].tag == tag {
                items[index].tag = nil
                // 更新数据库
                let entities = persistence.fetchPasteboardItems()
                if let entity = entities.first(where: { $0.id == items[index].id }) {
                    persistence.updatePasteboardItem(entity, content: nil, timestamp: nil, tag: nil, remark: nil, isPinned: nil)
                }
            }
        }
    }
    
    func renameTagInAllItems(oldName: String, newName: String) {
        for index in items.indices {
            if items[index].tag == oldName {
                items[index].tag = newName
                // 更新数据库
                let entities = persistence.fetchPasteboardItems()
                if let entity = entities.first(where: { $0.id == items[index].id }) {
                    persistence.updatePasteboardItem(entity, content: nil, timestamp: nil, tag: newName, remark: nil, isPinned: nil)
                }
            }
        }
    }
    
    func addItem(content: String, remark: String?) {
        let newItem = PasteboardItem(content: content, timestamp: Date(), tag: nil, remark: remark)
        withAnimation {
            items.insert(newItem, at: 0)
            sortItems()
        }
        // 保存到数据库
        persistence.addPasteboardItem(content: content, timestamp: newItem.timestamp, tag: nil, remark: remark, isPinned: false)
    }
    
    func addItem(content: String, remark: String?, tag: String?) {
        let newItem = PasteboardItem(content: content, timestamp: Date(), tag: tag, remark: remark)
        withAnimation {
            items.insert(newItem, at: 0)
            sortItems()
        }
        // 保存到数据库
        persistence.addPasteboardItem(content: content, timestamp: newItem.timestamp, tag: tag, remark: remark, isPinned: false)
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
        // 移动操作不需要更新数据库，因为排序是在内存中进行的
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
