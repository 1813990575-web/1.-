import SwiftUI

struct EditCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var item: PasteboardItem
    @State private var editedContent: String
    @State private var editedRemark: String
    var onSave: (String, String?) -> Void

    init(item: Binding<PasteboardItem>, onSave: @escaping (String, String?) -> Void) {
        self._item = item
        self._editedContent = State(initialValue: item.wrappedValue.content)
        self._editedRemark = State(initialValue: item.wrappedValue.remark ?? "")
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                TextEditor(text: $editedContent)
                    .font(.body)
                    .frame(minHeight: 60, maxHeight: 120)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        Group {
                            if editedContent.isEmpty {
                                Text("修改内容...")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .padding(.leading, 12)
                                    .padding(.top, 16)
                            }
                        },
                        alignment: .topLeading
                    )

                TextEditor(text: $editedRemark)
                    .font(.body)
                    .frame(height: 30)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        Group {
                            if editedRemark.isEmpty {
                                Text("添加备注...")
                                    .foregroundColor(.gray.opacity(0.5))
                                    .padding(.leading, 12)
                                    .padding(.top, 12)
                            }
                        },
                        alignment: .topLeading
                    )
            }
            .padding(20)

            HStack(spacing: 12) {
                Spacer()
                Button("取消") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.secondary)

                Button("保存") {
                    onSave(editedContent, editedRemark.isEmpty ? nil : editedRemark)
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.blue)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: 400)
        .background(Color(nsColor: .windowBackgroundColor).opacity(0.95))
        .cornerRadius(12)
        .shadow(radius: 20)
    }
}
