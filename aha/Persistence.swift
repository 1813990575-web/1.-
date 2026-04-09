import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "PasteboardModel")
        container.loadPersistentStores {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchPasteboardItems() -> [PasteboardItemEntity] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<PasteboardItemEntity>(entityName: "PasteboardItemEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PasteboardItemEntity.timestamp, ascending: false)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    func addPasteboardItem(content: String, timestamp: Date, tag: String?, remark: String?, isPinned: Bool) -> PasteboardItemEntity {
        let context = container.viewContext
        let item = PasteboardItemEntity(context: context)
        item.id = UUID()
        item.content = content
        item.timestamp = timestamp
        item.tag = tag
        item.remark = remark
        item.isPinned = isPinned
        save()
        return item
    }
    
    func deletePasteboardItem(_ item: PasteboardItemEntity) {
        let context = container.viewContext
        context.delete(item)
        save()
    }
    
    func updatePasteboardItem(_ item: PasteboardItemEntity, content: String?, timestamp: Date?, tag: String?, remark: String?, isPinned: Bool?) {
        let context = container.viewContext
        if let content = content {
            item.content = content
        }
        if let timestamp = timestamp {
            item.timestamp = timestamp
        }
        item.tag = tag
        item.remark = remark
        if let isPinned = isPinned {
            item.isPinned = isPinned
        }
        save()
    }
}