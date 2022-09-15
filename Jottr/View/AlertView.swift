//
//  AlertView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/13/22.
//

import SwiftUI

struct AlertView: View {
    // MARK: Properties
    
    @State var alertUser: Bool = false
    var title: String = ""
    var message: String = ""
    
    var body: some View {
        Text("Hello, World!")
            .onTapGesture {
//                alertUser = User()
            }
            .alert(title, isPresented: $alertUser, presenting: message) {_ in
                Button("OK") {}
            }
    }
}
