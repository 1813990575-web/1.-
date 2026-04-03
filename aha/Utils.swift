import SwiftUI

func truncateTagName(_ name: String) -> String {
    // 检查是否包含中文
    let containsChinese = name.contains { $0.isChineseCharacter }
    
    if containsChinese {
        // 中文限制5个字符
        if name.count > 5 {
            return String(name.prefix(5)) + "..."
        }
    } else {
        // 纯英文限制10个字符
        if name.count > 10 {
            return String(name.prefix(10)) + "..."
        }
    }
    return name
}

extension Character {
    var isChineseCharacter: Bool {
        guard let scalar = self.unicodeScalars.first else { return false }
        return (0x4E00...0x9FA5).contains(scalar.value)
    }
}
