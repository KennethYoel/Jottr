//
//  LogInView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/11/22.
//

import Foundation
import MessageUI
import StoreKit
import SwiftUI

// MARK: Custom Views

struct UserImage: View {
    /*
     Given the URL of the user’s picture, this view asynchronously
     loads that picture and displays it. It displays a “person”
     placeholder image while downloading the picture or if
     the picture has failed to download.
     https://auth0.com/blog/get-started-ios-authentication-swift-swiftui-part-2-user-profiles/
    */
      
    var urlString: String
      
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
                    .clipShape(Circle())
                
            } else if phase.error != nil {
                // Indicates an error.
                Image(systemName: "person.crop.circle.badge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
                    .clipShape(Circle())
            } else {
                // a placeholder image
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 64)
                    .clipShape(Circle())
            }
        }
    }
}

struct EmailAddress: View {
    var address: String
    
    var body: some View {
        HStack {
            Image(systemName: "envelope")
            Text(address)
        }
    }
}

struct UserDetails: View {
    var userProfile: UserProfile
    
    var body: some View {
        VStack {
            Text(userProfile.name)
                .font(.title)
                .foregroundColor(.primary)
            EmailAddress(address: userProfile.email)
        }
    }
}

struct UserView: View {
    var userProfile: UserProfile
    
    var body: some View {
        HStack {
            UserImage(urlString: userProfile.picture)
            UserDetails(userProfile: userProfile)
        }
    }
}

struct AccountView: View {
    // MARK: Properties

    @StateObject private var viewModel = AccountViewVM()
    @Environment(\.dismiss) var dismissAccountView
    private var storeReview = StoreReviewHelper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if viewModel.isAuthenticated {
                        HStack {
                            UserView(userProfile: viewModel.userProfile)
                        }
                    } else {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                            Button("Login", action: { viewModel.login() })
                        }
                    }
                }
                
                Section {
                    Button("Contact Support", action: { viewModel.sendEmail() })

    //                if viewModel.emailResult != nil {
    //                    Text(String(describing: emailResult))
    //                }
                    
                    Button("Leave Feedback") {
                        storeReview.requestReview()
                   }
                }
                
                Section {
                    Text("View Account Settings")
                }
                
                Section {
                    Button("Logout", action: { viewModel.logout() })
                }
                .disabled(!viewModel.isAuthenticated)
            }
            .sheet(isPresented: $viewModel.isShowingMailView) {
                MailView(isShowing: $viewModel.isShowingMailView, result: $viewModel.emailResult, showEmailResult: $viewModel.isShowingSendEmailAlert)
            }
            .alert(isPresented: $viewModel.isShowingSendEmailAlert, content: { viewModel.sendEmailAlert()
            })
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                topToolbar
            }
        }
    }
    
    var topToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done", action: { dismissAccountView() })
                .padding()
                .buttonStyle(.plain)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
