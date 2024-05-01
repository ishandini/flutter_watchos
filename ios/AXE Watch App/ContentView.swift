//
//  ContentView.swift
//  AXE Watch App
//
//  Created by Ishan on 2024-05-01.
//

import SwiftUI

struct ContentView: View {
    @StateObject var iOSConnector =  WatchToiOSConnector()

    var body: some View {
        VStack {
            Text("Counter: \(iOSConnector.counter)")
                .padding()
            Button(action: {
                iOSConnector.sendMessage(for: WatchSendMethod.sendCounterToFlutter.rawValue, data: ["counter": iOSConnector.counter + 1])
            }) {
                Text("+ by 2")
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
