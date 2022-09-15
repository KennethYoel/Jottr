//
//  LogInView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/11/22.
//

import SwiftUI

struct AccountView: View {
    // MARK: Properties
    
    @Environment(\.dismiss) var dismiss
    @State private var showingLoginScreen = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Spacer()
                Text("Account")
                    .padding()
                    .font(.headline)
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .padding()
                .font(.headline)
            }
            
            Form {
                Section {
                    Button {
                        showingLoginScreen.toggle()
                    } label: {
                        Label("Login", systemImage: "wallet.pass")
                    }
                }
            }
            .sheet(isPresented: $showingLoginScreen) {
                LoginView()
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}
