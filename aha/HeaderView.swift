
import SwiftUI

// L1 (Top) - 搜索栏
struct HeaderView: View {
    @Binding var searchText: String
    @Binding var currentView: ViewType

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Button(action: {
                    currentView = .settings
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("搜索剪贴板历史...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())

                if !searchText.isEmpty {
                    Button(action: { self.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
            .background(Color(nsColor: .black.withAlphaComponent(0.2)))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
