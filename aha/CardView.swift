
import SwiftUI
import Foundation

struct CardView: View {
    @EnvironmentObject var clipboardManager: ClipboardManager
    @EnvironmentObject var tagManager: TagManager
    let item: PasteboardItem
    @Binding var showToast: Bool
    @State private var showEditSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if item.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.blue)
                }
                
                Menu {
                    Button("无标签") {
                        clipboardManager.setTag(for: item, tag: nil)
                    }
                    
                    if !tagManager.tags.isEmpty {
                        Divider()
                        
                        ForEach(tagManager.tags, id: \.id) { tag in
                            Button(action: { clipboardManager.setTag(for: item, tag: tag.name) }) {
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(tag.color)
                                        .frame(width: 6, height: 6)
                                    Text(tag.name)
                                }
                            }
                        }
                    }
                } label: {
                    if let tag = item.tag {
                        if let color = tagManager.getTagColor(tag) {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 6, height: 6)
                                Text(truncateTagName(tag))
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(color.opacity(0.1))
                            .foregroundColor(color)
                            .cornerRadius(4)
                        } else {
                            Text(truncateTagName(tag))
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(4)
                        }
                    } else {
                        Text("无标签")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.gray)
                            .cornerRadius(4)
                    }
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .fixedSize()
                
                Text(item.formattedTimestamp)
                
                Spacer()
                
                Button(action: { clipboardManager.deleteItem(item) }) {
                    Image(systemName: "trash")
                }
                .buttonStyle(CardActionButtonStyle(defaultColor: .primary, hoverColor: .red))
            }
            .font(.caption)
            .foregroundColor(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                if let remark = item.remark, !remark.isEmpty {
                    Text(remark)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(2)
                }
                
                Text(item.content)
                    .lineLimit(1)
                    .font(.body)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white.opacity(0.6))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .contextMenu {
            Button(action: { clipboardManager.togglePin(for: item) }) {
                HStack {
                    Image(systemName: item.isPinned ? "pin.slash" : "pin")
                    Text(item.isPinned ? "取消置顶" : "置顶")
                }
            }
            
            Button(action: {
                showEditSheet = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("编辑卡片")
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditCardView(
                item: .constant(item),
                onSave: { newContent, newRemark in
                    clipboardManager.updateItem(item, newContent: newContent, newRemark: newRemark)
                }
            )
        }
        .onTapGesture {
            copyToPasteboard(item.content)
            triggerToast()
        }
    }

    private func copyToPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    private func triggerToast() {
        guard !showToast else { return }
        
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showToast = false
        }
    }
}
