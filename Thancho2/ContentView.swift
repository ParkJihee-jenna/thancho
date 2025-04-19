//
//  ContentView.swift
//  Thancho2
//
//  Created by 박지희 on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            LottieView(fileName: "Thancho", loopMode: .playOnce)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
