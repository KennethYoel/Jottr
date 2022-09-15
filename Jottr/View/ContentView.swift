//
//  ContentView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 8/10/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGenerationStore
//    @Binding var hadLaunched: Bool
    @State var currentView: String = "first" // use this ti change pages
    @State var showingAccountScreen = false
    @State private var showingLoginScreen = false
    @Binding var image: Image
    @Binding var inputImage: UIImage?
    
    // MARK: View
    
    var body: some View {
        LibraryView(image: $image, inputImage: $inputImage)
            .navigationTitle("🖋Jottr")
//        StoryCorpusView()
//        if(!hadLaunched) {
//            InitialView() //hadLaunched: $hadLaunched
//        } else {
//            StoryTellerView(generationModel: generationModel)
//        }
    }
}

/*
 @Binding,it allows us to create a two-way connection between PushButton and
 whatever is using it, so that when one value changes the other does too. Lets us
 store a mutable value in a view that actually points to some other value from
 elsewhere. In the case of Toggle, the switch changes its own local binding to a
 Boolean, but behind the scenes that’s actually manipulating the @State property of
 rememberMe in our view.
 */

//struct ContentView_Previews: PreviewProvider {
//    @Binding var image: Image
//    
//    static var previews: some View {
//        NavigationView {
//            ContentView(image: $image)
//                .environmentObject(TextGenerationStore())
//        }
//        .previewInterfaceOrientation(.portrait)
//    }
//}