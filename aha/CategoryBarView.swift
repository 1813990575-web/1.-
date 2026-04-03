
import SwiftUI

struct CategoryBarView: View {
    @EnvironmentObject var clipboardManager: ClipboardManager
    @EnvironmentObject var tagManager: TagManager
    @Binding var selectedCategory: CategoryType
    @State private var showAddTagSheet = false
    @State private var newTagName = ""
    @State private var showRenameSheet = false
    @State private var tagToRename = ""
    @State private var renamedTag = ""
    @State private var showDeleteConfirm = false
    @State private var tagToDelete = ""
    @State private var draggingTag: String?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button(action: { selectedCategory = .all }) {
                    Text("全部 \(countForCategory(.all))")
                }
                .buttonStyle(CategoryButtonStyle(isSelected: selectedCategory == .all))
                
                ForEach(tagManager.tags, id: \.id) { tag in
                    TagButton(
                        tag: tag,
                        count: countForCategory(.custom(tag.name)),
                        isSelected: selectedCategory == .custom(tag.name),
                        onTap: { selectedCategory = .custom(tag.name) },
                        onRename: {
                            tagToRename = tag.name
                            renamedTag = tag.name
                            showRenameSheet = true
                        },
                        onDelete: {
                            tagToDelete = tag.name
                            showDeleteConfirm = true
                        },
                        onDrag: {
                            draggingTag = tag.name
                            return NSItemProvider(object: tag.name as NSString)
                        },
                        onDrop: TagDropDelegate(
                            tag: tag.name,
                            tags: $tagManager.tags,
                            draggingTag: $draggingTag
                        )
                    )
                }
                
                Button(action: { showAddTagSheet = true }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(CategoryButtonStyle(isSelected: false))
            }
            .padding(.horizontal)
        }
        .alert("新建标签", isPresented: $showAddTagSheet) {
            TextField("标签名称", text: $newTagName)
            Button("取消", role: .cancel) {
                newTagName = ""
            }
            Button("确定") {
                if !newTagName.isEmpty {
                    tagManager.addTag(newTagName)
                    newTagName = ""
                }
            }
        }
        .alert("重命名标签", isPresented: $showRenameSheet) {
            TextField("新标签名称", text: $renamedTag)
            Button("取消", role: .cancel) {
                tagToRename = ""
                renamedTag = ""
            }
            Button("确定") {
                if tagManager.renameTag(oldName: tagToRename, newName: renamedTag) {
                    clipboardManager.renameTagInAllItems(oldName: tagToRename, newName: renamedTag)
                    if case .custom(let currentTag) = selectedCategory, currentTag == tagToRename {
                        selectedCategory = .custom(renamedTag)
                    }
                }
                tagToRename = ""
                renamedTag = ""
            }
        }
        .alert("删除标签", isPresented: $showDeleteConfirm) {
            Button("取消", role: .cancel) {
                tagToDelete = ""
            }
            Button("删除", role: .destructive) {
                clipboardManager.removeTagFromAllItems(tag: tagToDelete)
                tagManager.removeTag(tagToDelete)
                if case .custom(let currentTag) = selectedCategory, currentTag == tagToDelete {
                    selectedCategory = .all
                }
                tagToDelete = ""
            }
        } message: {
            Text("确定要删除标签「\(tagToDelete)」吗？该标签下的卡片将变为无标签状态。")
        }
    }

    private func countForCategory(_ category: CategoryType) -> Int {
        switch category {
        case .all:
            return clipboardManager.items.count
        case .custom(let tag):
            return clipboardManager.items.filter { $0.tag == tag }.count
        }
    }
}

struct TagDropDelegate: DropDelegate {
    let tag: String
    @Binding var tags: [TagInfo]
    @Binding var draggingTag: String?
    
    func performDrop(info: DropInfo) -> Bool {
        withAnimation(.easeInOut(duration: 0.2)) {
            draggingTag = nil
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggingTag = draggingTag,
              draggingTag != tag,
              let fromIndex = tags.firstIndex(where: { $0.name == draggingTag }),
              let toIndex = tags.firstIndex(where: { $0.name == tag }) else {
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            if fromIndex < toIndex {
                tags.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex + 1)
            } else {
                tags.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex)
            }
        }
    }
}

struct CategoryButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue : Color.clear)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct TagButton: View {
    let tag: TagInfo
    let count: Int
    let isSelected: Bool
    let onTap: () -> Void
    let onRename: () -> Void
    let onDelete: () -> Void
    let onDrag: () -> NSItemProvider
    let onDrop: TagDropDelegate
    @State private var isDragging = false
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(tag.color)
                .frame(width: 8, height: 8)
            Text("\(tag.name) \(count)")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isSelected ? Color.blue : Color.clear)
        .foregroundColor(isSelected ? .white : .primary)
        .cornerRadius(8)
        .scaleEffect(isDragging ? 1.1 : 1.0)
        .opacity(isDragging ? 0.7 : 1.0)
        .shadow(color: isDragging ? Color.black.opacity(0.15) : Color.clear, radius: isDragging ? 8 : 0)
        .animation(.easeInOut(duration: 0.2), value: isDragging)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            Button(action: onRename) {
                HStack {
                    Image(systemName: "pencil")
                    Text("重命名")
                }
            }
            
            Button(role: .destructive, action: onDelete) {
                HStack {
                    Image(systemName: "trash")
                    Text("删除标签")
                }
            }
        }
        .onDrag {
            isDragging = true
            return onDrag()
        }
        .onDrop(of: [.text], delegate: onDrop)
        .onAppear {
            isDragging = false
        }
    }
}
