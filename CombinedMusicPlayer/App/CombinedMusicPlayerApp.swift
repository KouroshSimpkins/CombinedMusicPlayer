//
//  CombinedMusicPlayerApp.swift
//  CombinedMusicPlayer
//
//  Created by Kourosh Simpkins on 22/05/2023.
//

import MusicKit
import SwiftUI

/// The main entry point for the app. 'CombinedMusicPlayerApp' conforms to the 'App' protocol.
@main
struct CombinedMusicPlayerApp: App {

    // MARK: - Object Lifecycle

    /// Configures the app when it launches.
    init() {
        adjustVisualAppearance()
    }

    // MARK: - App

    /// The app's root view.
    var body: some Scene {
        WindowGroup {
            ContentView()
                    .frame(minWidth: 400.0, minHeight: 200.0)
        }
    }

    // MARK: - Private Methods

    /// Configures the UI appearance of the app.
    private func adjustVisualAppearance() {
        var navigationBarLayoutMargins: UIEdgeInsets = .zero
        navigationBarLayoutMargins.left = 26.0
        navigationBarLayoutMargins.right = navigationBarLayoutMargins.left
        UINavigationBar.appearance().layoutMargins = navigationBarLayoutMargins

        var tableViewLayoutMargins: UIEdgeInsets = .zero
        tableViewLayoutMargins.left = 28.0
        tableViewLayoutMargins.right = tableViewLayoutMargins.left
        UITableView.appearance().layoutMargins = tableViewLayoutMargins
    }
}
