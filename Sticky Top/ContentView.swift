import SwiftUI

struct ContentView: View {
    @ObservedObject var store: StickyStore
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if store.stickies.isEmpty {
                    Spacer()
                    Text("No sticky notes. Click + to add one.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.stickies.indices, id: \.self) { index in
                                StickyView(sticky: $store.stickies[index], onDelete: {
                                    store.removeSticky(at: index)
                                })
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 50) // Add some padding at the bottom for fade effect
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color(.windowBackgroundColor)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 50)
                        }
                    )
                }
                Spacer(minLength: 40) // Reduced space for the button
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        store.addSticky()
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.blue)
                            .frame(width: 24, height: 24)
                            .background(Color.clear)
                    }
                    .padding([.trailing, .bottom], 8)
                }
            }
        }
        .frame(width: 300, height: 400)
        .background(Color(.windowBackgroundColor))
    }
}
