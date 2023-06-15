//
//  ContentView.swift
//  CombinedMusicPlayer
//
//  Created by Kourosh Simpkins on 22/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            SearchView()
        }
        .padding()
                .welcomeSheet()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
