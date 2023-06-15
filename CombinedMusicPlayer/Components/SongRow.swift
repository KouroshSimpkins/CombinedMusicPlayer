//
// Created by Kourosh Simpkins on 07/06/2023.
//

import Foundation
import MusicKit
import SwiftUI
import MediaPlayer

// MARK: - A "Song Row" view

/// A view that displays a single song. We use this view in the Search screen to display the results of a search.
/// The view is a horizontal stack of views, with the song's artwork on the left, and the song's title,
/// artist, and album on the right.

struct SongRow: View {
	// MARK: - Properties

	// The song to display.
	let songItem: SongItem

	// MARK: - View

	var body: some View {
		HStack {
			artwork
			VStack(alignment: .leading) {
				title
				artist
				album
			}
		}
	}

	// MARK: - Subviews

	// The song's artwork.
	var artwork: some View {
		AsyncImage(url: songItem.imageURL) { image in
			image.resizable()
		} placeholder: {
			Image(systemName: "music.note")
					.resizable()
		}
				.frame(width: 50, height: 50)
				.cornerRadius(5)
	}

	// The song's title.
	var title: some View {
		Text(songItem.name)
				.font(.headline)
	}

	// The song's artist.
	var artist: some View {
		Text(songItem.artist)
				.font(.subheadline)
	}

	// The song's album.
	var album: some View {
		Text(songItem.album)
				.font(.subheadline)
	}
}