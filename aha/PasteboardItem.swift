
import Foundation
import CoreData

enum ItemType: String, CaseIterable {
    case all = "全部"
}

enum CategoryType: Equatable {
    case all
    case custom(String)
    
    var displayName: String {
        switch self {
        case .all:
            return "全部"
        case .custom(let tag):
            return tag
        }
    }
}

struct PasteboardItem: Identifiable, Equatable {
    let id = UUID()
    var content: String
    var timestamp: Date
    var tag: String?
    var remark: String? = nil
    var isPinned: Bool = false

    var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: timestamp)
    }
    
    init(content: String, timestamp: Date, tag: String?, remark: String?) {
        self.content = content
        self.timestamp = timestamp
        self.tag = tag
        self.remark = remark
    }
    
    init(entity: PasteboardItemEntity) {
        self.content = entity.content
        self.timestamp = entity.timestamp
        self.tag = entity.tag
        self.remark = entity.remark
        self.isPinned = entity.isPinned
    }
    
    func toEntity(context: NSManagedObjectContext) -> PasteboardItemEntity {
        let entity = PasteboardItemEntity(context: context)
        entity.id = self.id
        entity.content = self.content
        entity.timestamp = self.timestamp
        entity.tag = self.tag
        entity.remark = self.remark
        entity.isPinned = self.isPinned
        return entity
    }
}

// PRD: Mock 填充
struct MockData {
    static let items: [PasteboardItem] = [
        PasteboardItem(content: "这是第一条纯文本消息。", timestamp: Date().addingTimeInterval(-10), tag: nil, remark: nil),
        PasteboardItem(content: "https://www.apple.com", timestamp: Date().addingTimeInterval(-25), tag: nil, remark: nil),
        PasteboardItem(content: "/Users/aha/Documents/我造的应用/aha/aha/Assets.xcassets/AppIcon.appiconset/icon_128x128.png", timestamp: Date().addingTimeInterval(-45), tag: nil, remark: nil),
        PasteboardItem(content: "SwiftUI is a powerful framework for building user interfaces.", timestamp: Date().addingTimeInterval(-60), tag: nil, remark: nil),
        PasteboardItem(content: "这是另一条长文本消息，用于测试多行文本的显示效果，确保卡片能够正确地自适应高度。", timestamp: Date().addingTimeInterval(-80), tag: nil, remark: nil),
        PasteboardItem(content: "https://github.com/trae-ai", timestamp: Date().addingTimeInterval(-120), tag: nil, remark: nil),
        PasteboardItem(content: "这是一条测试数据。", timestamp: Date().addingTimeInterval(-150), tag: nil, remark: nil),
        PasteboardItem(content: "/Users/aha/Pictures/wallpaper.jpg", timestamp: Date().addingTimeInterval(-180), tag: nil, remark: nil),
        PasteboardItem(content: "https://www.google.com", timestamp: Date().addingTimeInterval(-220), tag: nil, remark: nil),
        PasteboardItem(content: "最后一条用于填充列表的文本记录。", timestamp: Date().addingTimeInterval(-300), tag: nil, remark: nil)
    ]
}
