//
//  ContentView.swift
//  AlertAndSheet
//
//  Created by sakai.yunosuke on 2025/05/12.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresentedFirstSheet = false
    
    var body: some View {
        VStack {
            Button(action: { isPresentedFirstSheet = true }) {
                Text("Open first sheet")
            }
        }
        .sheet(isPresented: $isPresentedFirstSheet) {
            FirstSheetView(
                store: .init(initialState: .init()) {
                    FirstSheet()
                }
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
