//
// Created by Kourosh Simpkins on 01/06/2023.
//

import Foundation
import SwiftUI
import MusicKit

// MARK: - Song Item Structure
struct SongItem: Identifiable, Hashable {
    let id = UUID()
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

    // MARK: - View
    var body: some View {
        SearchBar(text: $searchText, isSearching: $isSearching)
        NavigationView {
            List(songs) { song in
                HStack {
                    AsyncImage(url: song.imageURL) { image in
                        image.resizable()
                    } placeholder: {
                        Image(systemName: "music.note")
                                .resizable()
                    }
                            .frame(width: 50, height: 50)
                            .cornerRadius(5)
                    VStack(alignment: .leading) {
                        Text(song.name)
                                .font(.headline)
                        Text(song.artist)
                                .font(.subheadline)
                        Text(song.album)
                                .font(.subheadline)
                    }

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
                            name: $0.title,
                            artist: $0.artistName,
                            album: $0.albumTitle ?? "",
                            imageURL: $0.artwork?.url(width: 75, height: 75),
                            streamURL: $0.url
                        )
                    })
                    print(String(describing: songs[0]))
                    return
                } catch {
                    print(String(describing: error))
                    songs = []
                    return
                }
            }
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
