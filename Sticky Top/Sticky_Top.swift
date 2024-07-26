import SwiftUI

struct Sticky: Identifiable {
    let id = UUID()
    let date: Date
    var text: String
    var color: Color = .yellow
}

class StickyStore: ObservableObject {
    @Published var stickies: [Sticky] = []
    
    func addSticky() {
        stickies.insert(Sticky(date: Date(), text: ""), at: 0)
    }
    
    func removeSticky(at index: Int) {
        guard index >= 0 && index < stickies.count else { return }
        stickies.remove(at: index)
    }
}
