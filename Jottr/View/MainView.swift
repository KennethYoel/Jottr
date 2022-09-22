//
//  MainView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/13/22.
//

import SwiftUI

struct MainView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGeneration
    @Binding var hadLaunched: Bool
    
    var body: some View {
        // initial view
        NavigationView {
            ContentView(currentView: .library) //, hadLaunched: $hadLaunched
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(hadLaunched: .constant(false))
            .environmentObject(TextGeneration())
    }
}
