//
// Created by Kourosh Simpkins on 01/06/2023.
//

import Foundation
import SwiftUI
import MusicKit

// MARK: - Song Item Structure
struct SongItem: Identifiable, Hashable {
    let id = UUID()
    let StringID: String // The ID of the song in the Apple Music catalog.
    let name: String
    let artist: String
    let album: String
    let imageURL: URL?
    let streamURL: URL?
}

// MARK: - Search View
struct SearchView: View {

    // MARK: - Properties
    @State private var searchText = String()
    @State private var isSearching = false
    @State var songs = [SongItem]()
    @StateObject var playerManager = PlayerManager()

    // MARK: - View
    var body: some View {
        SearchBar(text: $searchText, isSearching: $isSearching)
        NavigationView {
            List(songs) { song in
                NavigationLink(destination: PlayerView(playerManager: playerManager, songID: song.StringID)) {
                    SongRow(songItem: song)
                }
            }
                    .navigationTitle("Search")
                    .onChange(of: searchText) { searchText in
                        search(for: searchText)
                    }
        }
    }

    private let requests: MusicCatalogSearchRequest = {
        // This search request should take the term the user entered in the search bar, and return the first 10 songs that match that term.
        var request = MusicCatalogSearchRequest(term: "First Step", types: [Song.self])

        request.limit = 10
        return request
    }()

    // MARK: - Methods
    private func search(for searchText: String) {
        // Request -> Response
        Task {
            if searchText.isEmpty {
                songs = []
                return
            } else {
                do {
                    var request = MusicCatalogSearchRequest(term: searchText, types: [Song.self])
                    request.limit = 15
                    let result = try await request.response()
                    self.songs = result.songs.compactMap({
                        .init(
                            StringID: $0.id.rawValue,
                            name: $0.title,
                            artist: $0.artistName,
                            album: $0.albumTitle ?? "",
                            imageURL: $0.artwork?.url(width: 75, height: 75),
                            streamURL: $0.url
                        )
                    })

                    // Each song in the search result should be displayed using the SongRow view.
                    // The SongRow view should display the song's artwork, title, artist, and album.
                    // When the user taps on a song, the song should be sent to the playerView.
                    // The playerView should then play the song.

                    return
                } catch {
                    print(String(describing: error))
                    songs = []
                    return
                }
            }
        }
    }

    // When the user taps on a song we want to make sure the song data is passed to the playerView
    // We can do this by passing the song data to the playerView using the NavigationLink

    // MARK: - Navigation
    private func navigationLink(for song: SongItem) -> some View {
        NavigationLink(destination: PlayerView(playerManager: playerManager, songID: song.StringID)) {
        }
    }
}


// MARK: - Search Bar
struct SearchBar: View {

    // MARK: - Properties
    @Binding var text: String
    @Binding var isSearching: Bool

    // MARK: - View
    var body: some View {
        HStack {
            TextField("Search for a song...", text: $text)
                    .padding(.leading, 24)
        }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(6)
                .padding(.horizontal)
                .onTapGesture {
                    isSearching = true
                }
                .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Spacer()
                            if isSearching {
                                Button(action: {
                                    text = ""
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                            .padding(.vertical)
                                })
                            }
                        }
                                .padding(.horizontal, 32)
                                .foregroundColor(.gray)
                )
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
