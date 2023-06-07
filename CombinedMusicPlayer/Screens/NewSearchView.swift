//
// Created by Kourosh Simpkins on 01/06/2023.
//

import Foundation
import SwiftUI
import MusicKit

struct SongItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let artist: String
    let album: String
    let imageURL: URL?
}

struct SearchView: View {
    @State var songs = [SongItem]()

    var body: some View {
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
                    .onAppear {
                        search()
                    }
        }
    }

    private let requests: MusicCatalogSearchRequest = {
        var request = MusicCatalogSearchRequest(term: "Taylor Swift", types: [Song.self])

        request.limit = 10
        return request
    }()

    private func search() {
        // Request -> Response
        Task {
            do {
                let result = try await requests.response()
                self.songs = result.songs.compactMap({
                    .init(
                        name: $0.title,
                        artist: $0.artistName,
                        album: $0.albumTitle ?? "",
                        imageURL: $0.artwork?.url(width: 100, height: 100)
                    )
                })
                print(String(describing: songs[0]))
            } catch {
                print(String(describing: error))
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: {
                onSearch()
            })
                    .padding(.leading, 24)

            if isSearching {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                            .padding(.trailing, 8)
                }
            }
        }
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .padding(.horizontal)
                .onTapGesture {
                    isSearching = true
                }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
