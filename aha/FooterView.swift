
import SwiftUI

struct FooterView: View {
    @State private var contentText: String = ""
    @State private var remarkText: String = ""
    @FocusState private var isContentFocused: Bool
    var currentTag: String?
    var onCommit: (String, String?, String?) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    TextField("粘贴新内容...", text: $contentText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 8)
                        .onSubmit { commit() }
                        .onCommand("\t") {
                            NSApp.sendAction(#selector(NSTextView.insertTab(_:)), to: nil, from: nil)
                        }
                        .focused($isContentFocused)

                    Spacer()
                        .frame(width: 24)
                }
                .padding(EdgeInsets(top: 4, leading: 15, bottom: 4, trailing: 15))
                
                Divider()
                    .opacity(0.3)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                HStack(alignment: .center, spacing: 12) {
                    TextField("添加备注...", text: $remarkText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 4)
                        .onSubmit { commit() }
                        .onCommand("\t") {
                            NSApp.sendAction(#selector(NSTextView.insertTab(_:)), to: nil, from: nil)
                        }

                    Spacer()
                        .frame(width: 24)
                }
                .padding(EdgeInsets(top: 4, leading: 15, bottom: 4, trailing: 15))
            }
            .background(Color(nsColor: .windowBackgroundColor))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isContentFocused = true
                }
            }
        }
    }

    private func commit() {
        if !contentText.isEmpty {
            onCommit(contentText, remarkText.isEmpty ? nil : remarkText, currentTag)
            DispatchQueue.main.async {
                self.contentText = ""
                self.remarkText = ""
            }
        }
    }
}
