//
// Created by Kourosh Simpkins on 01/06/2023.
//

import Foundation
import SwiftUI

// MARK: - The Prominent Button Style
struct ProminentButtonStyle: ButtonStyle {

	@Environment(\.colorScheme) private var colorScheme: ColorScheme

	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
				.font(.title3.bold())
				.foregroundColor(.accentColor)
				.padding()
				.background(backgroundColour.cornerRadius(8))
				.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
				.animation(.easeInOut(duration: 0.2))
	}

	private var backgroundColour: Color {
		Color(uiColor: (colorScheme == .dark ? .secondarySystemBackground : .systemBackground))
	}
}

// MARK: - Button Style Extension
extension ButtonStyle where Self == ProminentButtonStyle {
	static var prominent: ProminentButtonStyle {
		ProminentButtonStyle()
	}
}
