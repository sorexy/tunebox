enum RepeatMode: CaseIterable {
    case none
    case queue
    case one

    var systemImageName: String {
        switch self {
        case .none:  return "repeat"
        case .queue: return "repeat"
        case .one:   return "repeat.1"
        }
    }

    var isActive: Bool {
        self != .none
    }
}
