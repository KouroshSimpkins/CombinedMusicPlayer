//
// Created by Kourosh Simpkins on 12/06/2023.
//

import Foundation
import SwiftUI
import MusicKit
import MediaPlayer


// MARK: - PlayerManager

/// The PlayerManager is an ObservableObject that manages the playback of songs.
/// It is responsible for playing, pausing, and skipping songs, and for updating the UI when the song changes.

class PlayerManager: ObservableObject {
	// MARK: - Properties

	@Published var player: MPMusicPlayerController = MPMusicPlayerController.applicationMusicPlayer

	func playSong(with id: String) {
		// This function should play the song with the given ID.
		let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [id])
		player.setQueue(with: descriptor)
		player.prepareToPlay() { (error) in
			if error == nil {
				self.player.play()
			}
		}
	}
}

// MARK: - The Player View

/// The now playing view. This view displays the currently playing song, and allows the user to control playback.
/// The SongItem that is selected in the SearchView is passed to this view, and the song is played.///

struct PlayerView: View {
	@ObservedObject var playerManager: PlayerManager

	var songID: String

	var body: some View {
		VStack {
			Text("Now Playing")
					.font(.largeTitle)
					.padding()

			Button(action: {
				playerManager.playSong(with: songID)
			}) {
				Text("Play Song")
						.font(.title)
						.padding()
						.background(Color.blue)
						.foregroundColor(.white)
						.cornerRadius(10)
			}
		}
	}
}


// MARK: - Preview

struct PlayerView_Previews: PreviewProvider {
	static var previews: some View {
		Text("View cannot be previewed in simulator.")
	}
}
