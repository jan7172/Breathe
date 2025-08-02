import SwiftUI

enum SocialApp: String, CaseIterable {
    case instagram, snapchat, youtube, tiktok
    
    var displayName: String {
        switch self {
        case .instagram: return "Instagram"
        case .snapchat: return "Snapchat"
        case .youtube: return "YouTube"
        case .tiktok: return "TikTok"
        }
    }
    
    var color: Color {
        switch self {
        case .instagram: return .purple
        case .snapchat: return .yellow
        case .youtube: return .red
        case .tiktok: return .brown
        }
    }
    
    var urlScheme: String {
        switch self {
        case .instagram: return "instagram://"
        case .snapchat: return "snapchat://"
        case .youtube: return "youtube://"
        case .tiktok: return "tiktok://"
        }
    }
}
