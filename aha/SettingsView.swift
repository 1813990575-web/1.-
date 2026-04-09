import SwiftUI

struct SettingsView: View {
    @Binding var currentView: ViewType
    
    var body: some View {
        SettingsMainView(currentView: $currentView)
    }
}

struct SettingsMainView: View {
    @Binding var currentView: ViewType
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    currentView = .main
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("设置")
                    .font(.headline)
                
                Spacer()
            }
            .padding()
            
            VStack(spacing: 0) {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "internaldrive")
                                .foregroundColor(.gray)
                                .frame(width: 20, height: 20)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("本地存储")
                                    .font(.body)
                                Text("剪贴板历史保存在当前 Mac 上")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Divider()

                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.shield")
                                .foregroundColor(.green)
                                .frame(width: 20, height: 20)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("当前状态")
                                    .font(.body)
                                Text("应用已启用本地持久化。重启应用后，剪贴板记录、标签和备注都会继续保留。")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color(nsColor: .windowBackgroundColor))
                }
            }
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            Spacer()
        }
        .padding()
    }
}
