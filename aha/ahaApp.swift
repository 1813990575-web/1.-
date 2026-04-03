//
//  ahaApp.swift
//  aha
//
//  Created by OneOne on 2026/3/13.
//

import SwiftUI
import Combine

@main
struct ahaApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    
    private var panelSettings = PanelSettings()
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "clipboard")
            button.action = #selector(statusBarButtonClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        self.popover = NSPopover()
        self.popover?.behavior = .transient
        let clipboardManager = ClipboardManager()
        let tagManager = TagManager()
        let contentView = ContentView()
            .environmentObject(clipboardManager)
            .environmentObject(panelSettings)
            .environmentObject(tagManager)
        self.popover?.contentViewController = NSHostingController(rootView: contentView)
        self.popover?.contentSize = NSSize(width: 400, height: panelSettings.height)
        
        panelSettings.$height
            .debounce(for: .milliseconds(10), scheduler: RunLoop.main)
            .sink { [weak self] newHeight in
                self?.popover?.contentSize.height = newHeight
            }
            .store(in: &cancellables)
    }

    @objc func statusBarButtonClicked() {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            let menu = NSMenu()
            menu.addItem(
                withTitle: "退出",
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: ""
            )
            statusItem?.menu = menu
            statusItem?.button?.performClick(nil)
            statusItem?.menu = nil
        } else {
            togglePopover()
        }
    }

    @objc func togglePopover() {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(nil)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
