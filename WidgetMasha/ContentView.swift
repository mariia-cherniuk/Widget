//
//  ContentView.swift
//  WidgetMasha
//
//  Created by Mariia Cherniuk on 16/07/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!").padding()
            .onOpenURL { url in
                print("URL received: \(url)")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
