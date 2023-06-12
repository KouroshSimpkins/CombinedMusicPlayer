//
// WelcomeView.swift
// CombinedMusicPlayer
//
// Created by Kourosh Simpkins on 01/06/2023.
//

import MusicKit
import Foundation
import SwiftUI
 
// MARK: - Welcome view

/// The welcome view.
/// This view is shown when the user first launches the app.
/// It allows the user to sign in to their Apple Music account.
/// Once the user is signed in, the app will transition to the main screen.
/// If the user is already signed in, the app will transition to the main screen immediately.
///
/// This view should be presented as a sheet using the convenience '.welcomeSheet()' modifier.
///

struct WelcomeView: View {

	// MARK: - Properties

	/// The current authorisation state of MusicKit
	@Binding var musicAuthorizationState: MusicAuthorization.Status

	/// Opens a URL using the appropriate system service.
	@Environment(\.openURL) private var openURL

	// MARK: - View

	/// A declaration of the UI that this view presents
	var body: some View {
		ZStack {
			gradient
			VStack {
				Text("Combined Queue")
						.foregroundColor(.primary)
						.font(.largeTitle.weight(.semibold))
						.shadow(radius: 2)
						.padding(.bottom, 1)
				Text("Use multiple streaming services.")
						.foregroundColor(.primary)
						.font(.title2.weight(.medium))
						.multilineTextAlignment(.center)
						.shadow(radius: 1)
						.padding([.leading, .trailing], 32)
						.padding(.bottom, 16)
				explanatoryText
						.foregroundColor(.primary)
						.font(.title3.weight(.medium))
						.multilineTextAlignment(.center)
						.shadow(radius: 1)
						.padding([.leading, .trailing], 32)
						.padding(.bottom, 16)
				if let secondaryExplanatoryText =
					secondaryExplanatoryText {
					secondaryExplanatoryText
							.foregroundColor(.primary)
							.font(.title3.weight(.medium))
							.multilineTextAlignment(.center)
							.shadow(radius: 1)
							.padding([.leading, .trailing], 32)
							.padding(.bottom, 16)
				}
				if musicAuthorizationState == .notDetermined ||
					   musicAuthorizationState == .denied {
					Button(action: handleButtonPressed) {
						buttonText
								.padding([.leading, .trailing], 10)
					}
                            .buttonStyle(.prominent)
							.colorScheme(.light)
				}
			}
					.colorScheme(.dark)
		}
	}

	/// Constructs a gradient to use as the view background
	private var gradient: some View {
		LinearGradient(
			gradient: Gradient(colors: [
				Color(red: (252.0 / 255.0), green: (60.0 / 255.0), blue: (68.0 / 255.0)),
				Color(red: (9.0 / 255.0), green: (29.0 / 255.0), blue: (56.0 / 255.0)),
				Color(red: (49.0 / 255.0), green: (64.0 / 255.0), blue: (110.0 / 255.0))
			]),
			startPoint: .top,
			endPoint: .bottom
		)
				.flipsForRightToLeftLayoutDirection(false)
				.ignoresSafeArea()
	}

	/// The explanatory text to display. This should change depending on if the application is authorised or not.
	private var explanatoryText: Text {
		let explanatoryText: Text
		switch musicAuthorizationState {
		case .restricted:
			explanatoryText = Text("You cannot use this app because you are not authorised to use ") +
				Text(Image(systemName: "applelogo")) + Text(" Music.")
		default:
			explanatoryText = Text("Combined Music Player uses ") +
				Text(Image(systemName: "applelogo")) + Text(" Music to provide a combined queue of songs from multiple streaming services.")
		}
		return explanatoryText
	}

	/// A secondary explanation text which explains how to grant apple music access.
	private var secondaryExplanatoryText: Text? {
		let secondaryExplanatoryText: Text?
		switch musicAuthorizationState {
		case .notDetermined:
			secondaryExplanatoryText = Text("To continue, you must grant access to your ") +
				Text(Image(systemName: "applelogo")) + Text(" Music library.")
		case .denied:
			secondaryExplanatoryText = Text("To continue, you must grant access to your ") +
				Text(Image(systemName: "applelogo")) + Text(" Music library. You can do this in the Settings app.")
		default:
			secondaryExplanatoryText = nil
		}
		return secondaryExplanatoryText
	}

	/// The text to display on the button. This should change depending on if the application is authorised or not.
	private var buttonText: Text {
		let buttonText: Text
		switch musicAuthorizationState {
		case .notDetermined:
			buttonText = Text("Continue")
		case .denied:
			buttonText = Text("Open Settings")
		default:
			fatalError("No button should be displayed for current authorization status: \(musicAuthorizationState).")
		}
		return buttonText
	}

	// MARK: - Methods

	/// Allows the user to authorize the Apple Music Usage when tapping the Continue/Open Settings button.
	private func handleButtonPressed() {
		switch musicAuthorizationState {
		case .notDetermined:
			Task {
				let musicAuthorizationState = await
					MusicAuthorization.request()
				await update(with: musicAuthorizationState)
			}
		case .denied:
			if let settingsURL = URL(string:
				UIApplication.openSettingsURLString) {
				openURL(settingsURL)
			}
		default:
			fatalError("No button should be displayed for current authorization status: \(musicAuthorizationState).")
		}
	}

	/// safely update the 'musicAuthorizationState' property on the main thread.
	@MainActor
	private func update(with musicAuthorizationState:
		MusicAuthorization.Status) {
		withAnimation {
			self.musicAuthorizationState = musicAuthorizationState
		}
	}

	// MARK: - Presentation Coordinator

	/// A presentation coordinator that is used together with 'SheetPresentationModifier' to present the welcome view as a sheet.
	class PresentationCoordinator: ObservableObject {
		static let shared = PresentationCoordinator()

		private init() {
			let authorisationStatus = MusicAuthorization.currentStatus
			musicAuthorizationState = authorisationStatus
			isWelcomeViewPresented = (authorisationStatus != .authorized)
		}

		@Published var musicAuthorizationState:
			MusicAuthorization.Status {
			didSet {
				isWelcomeViewPresented = (musicAuthorizationState != .authorized)
			}
		}

		@Published var isWelcomeViewPresented: Bool
	}

	// MARK: - Sheet Presentation Modifier

	/// A modifier which presents the welcome view as a sheet.
	fileprivate struct SheetPresentationModifier: ViewModifier {
		@StateObject private var presentationCoordinator = PresentationCoordinator.shared

		func body(content: Content) -> some View {
			content
				.sheet(isPresented: $presentationCoordinator.isWelcomeViewPresented) {
					WelcomeView(musicAuthorizationState: $presentationCoordinator.musicAuthorizationState)
							.interactiveDismissDisabled()
				}
		}
	}
}

// MARK: - View extension

/// A convenience extension to present the welcome view as a sheet.
extension View {
	func welcomeSheet() -> some View {
		modifier(WelcomeView.SheetPresentationModifier())
	}
}

// MARK: - Previews

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView(musicAuthorizationState: .constant(.notDetermined))
	}
}
