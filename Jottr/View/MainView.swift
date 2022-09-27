//
//  MainView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/13/22.
//

import SwiftUI

struct MainView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: GenTextViewModel
    @Binding var hadLaunched: Bool
    
    var body: some View {
        // initial view - a random quote page "I have been blessed with a wilder mind."
        NavigationView {
            ContentView(currentView: .library) //, hadLaunched: $hadLaunched
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(hadLaunched: .constant(false))
            .environmentObject(GenTextViewModel())
    }
}
