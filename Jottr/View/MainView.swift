//
//  MainView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/13/22.
//

import SwiftUI

struct MainView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGenerationStore
    @Binding var hadLaunched: Bool
    
    @State private var showingLoginScreen = false
    @State private var showingSearchScreen = false
    
    @State var image: Image = Image("noImagePlaceholder")
    @State var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        // initial view
        NavigationView {
            ContentView(image: $image, inputImage: $inputImage) //, hadLaunched: $hadLaunched
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        NavigationLink(destination: StoryTellerView()) {
                            Label("New Story", systemImage: "square.and.pencil")
                        }
                        
                        Menu {
                            Button {
                                showingLoginScreen.toggle()
                            } label: {
                                Label("Login", systemImage: "lanyardcard")
                            }
                            
                            NavigationLink { // this belongs with create a story view
                                PromptSettingsView()
                            } label: {
                                Label("Prompt Settings", systemImage: "doc.badge.gearshape")
                            }
                            
                            Button {
                                showingImagePicker.toggle()
                            } label: {
                                Text("Images")
                                Image(systemName: "arrow.up.and.down.circle")
                            }
                        } label: {
                             Image(systemName: "gearshape.2")
                        }
                    }
                }
                .onChange(of: inputImage) { _ in loadImage() }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    Button {
                        showingSearchScreen.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .symbolRenderingMode(.multicolor)
                            .padding([.trailing], 25)
                    }
                    .accessibilityLabel("Show Search")
                }
                .sheet(isPresented: $showingSearchScreen) { SearchView() }
                .sheet(isPresented: $showingLoginScreen) { LoginView() }
                .sheet(isPresented: $showingImagePicker) { ImagePicker(image: $inputImage) }
        }
    }
    
    /*
     A method we can call when that property changes. Remember, we can’t use a plain property
     observer here because Swift will ignore changes to the binding, so instead we’ll write a
     method that checks whether inputImage has a value, and if it does uses it to assign a new
     Image view to the image property.
     */
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

//struct MainView_Previews: PreviewProvider {
//    @State private var hadLaunched = UserDefaults.standard.bool(forKey: "hadLaunched")
//    
//    static var previews: some View {
//        MainView(hadLaunched: hadLaunched)
//            .environmentObject(TextGenerationStore())
//    }
//}
