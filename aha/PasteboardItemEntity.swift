import Foundation
import CoreData

class PasteboardItemEntity: NSManagedObject {
    @NSManaged var content: String
    @NSManaged var id: UUID
    @NSManaged var isPinned: Bool
    @NSManaged var remark: String?
    @NSManaged var tag: String?
    @NSManaged var timestamp: Date
}

extension PasteboardItemEntity {
    static func fetchRequest() -> NSFetchRequest<PasteboardItemEntity> {
        return NSFetchRequest<PasteboardItemEntity>(entityName: "PasteboardItemEntity")
    }
}