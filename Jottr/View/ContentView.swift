//
//  ContentView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import Foundation
import SwiftUI

enum LoadingState {
    case notebook, storyList, accountView
    
    var stringValue: String {
        switch self {
        case .notebook:
            return "notebook"
        case .storyList:
            return "storyList"
        case .accountView:
            return "accountView"
        }
    }
}

struct ContentView: View {
    // MARK: Properties
    
    @EnvironmentObject var network: NetworkMonitor
    @State private var showNetworkAlert: Bool = false
    var currentView = LoadingState.notebook
    // used for state restoration
//    @SceneStorage("reLaunchView") var reLaunchView = ""
//    @AppStorage("hasLauncehd") private var hasLaunched = false
    
    var body: some View {
        // initial view - a random quote page "I have been blessed with a wilder mind."
        switch currentView {
        case .notebook:
            NavigationView {
                NoteBookView()
                    .onAppear {
                        if !network.isActive {
                            showNetworkAlert.toggle()
                            UserDefaults.standard.object(forKey: "reLaunchView")
                        }
                    }
                    .alert(isPresented: $showNetworkAlert) {
                        Alert(title: Text("Device Offline"),
                              message: Text("Turn Off AirPlane Mode or Use Wi-Fi to Access Data"),
                              dismissButton: .default(
                                Text("OK")
                              )
                        )
                    }
            }
        case .storyList:
            StoryListView()
        case .accountView:
            AccountView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
