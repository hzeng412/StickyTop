import SwiftUI

var globalStore: StickyStore!

@main
struct Sticky_TopApp: App {
    @StateObject private var store: StickyStore
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    init() {
        let newStore = StickyStore()
        _store = StateObject(wrappedValue: newStore)
        globalStore = newStore
    }

    var body: some Scene {
        Settings {
            ContentView(store: store)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "note.text", accessibilityDescription: "Sticky Top")
            button.action = #selector(togglePopover)
        }
        
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 300, height: 400)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: ContentView(store: globalStore))
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "n" {
                self?.createNewSticky()
                return nil
            }
            return event
        }
    }
    
    @objc func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
            } else {
                createNewSticky() // Create a new sticky when opening the popover
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover?.contentViewController?.view.window?.makeKey()
            }
        }
    }
    
    func createNewSticky() {
        globalStore.addSticky()
        // Update the popover's content view to reflect the new sticky
        if let contentView = popover?.contentViewController as? NSHostingController<ContentView> {
            contentView.rootView = ContentView(store: globalStore)
        }
    }
}
