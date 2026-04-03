import SwiftUI
import Combine

struct TagInfo: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let color: Color
    
    static func == (lhs: TagInfo, rhs: TagInfo) -> Bool {
        return lhs.name == rhs.name
    }
}

class TagManager: ObservableObject {
    @Published var tags: [TagInfo] = []
    
    private let tagColors: [Color] = [
        .orange, .purple, .pink, .indigo, .teal
    ]
    
    func addTag(_ tag: String) {
        if !tag.isEmpty && !tags.contains(where: { $0.name == tag }) {
            var colorIndex = tags.count % tagColors.count
            
            // 确保相邻标签颜色不同
            if !tags.isEmpty {
                let lastTagColor = tags.last!.color
                if let lastColorIndex = tagColors.firstIndex(of: lastTagColor) {
                    colorIndex = (lastColorIndex + 1) % tagColors.count
                }
            }
            
            let color = tagColors[colorIndex]
            tags.append(TagInfo(name: tag, color: color))
        }
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll { $0.name == tag }
    }
    
    func renameTag(oldName: String, newName: String) -> Bool {
        guard !newName.isEmpty else { return false }
        guard let index = tags.firstIndex(where: { $0.name == oldName }) else { return false }
        guard !tags.contains(where: { $0.name == newName }) else { return false }
        
        tags[index] = TagInfo(name: newName, color: tags[index].color)
        return true
    }
    
    func getAllTags() -> [String] {
        return ["无标签"] + tags.map { $0.name }
    }
    
    func getTagColor(_ tagName: String) -> Color? {
        return tags.first(where: { $0.name == tagName })?.color
    }
}
