//
//  MainView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/13/22.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 255 / 255, green: 255 / 255, blue: 235 / 255)
}

struct MainView: View {
    // MARK: Properties
    
    @EnvironmentObject var textGeneration: TextGeneration
    @Binding var hadLaunched: Bool
    
    @State private var showingAddStoryScreen = false
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
                        NavigationLink(destination: StoryEditorView(currentView: .constant(.storyEditor))) {
                            Label("New Story", systemImage: "square.and.pencil")
                        }
                        
                        Menu {
                            Button { // this belongs with create a story view
                                showingAddStoryScreen.toggle()
                            } label: {
                                Label("Prompt Editor", systemImage: "doc.badge.gearshape")
                            }
                            
                            Button {
                                showingLoginScreen.toggle()
                            } label: {
                                Label("Login", systemImage: "lanyardcard")
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
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 45, height: 45)
                            .padding([.trailing], 25)
                        Button {
                            showingSearchScreen.toggle()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .renderingMode(.original)
                                .font(.headline)
                                .padding([.trailing], 25)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Show Search")
                    }
                }
                .sheet(isPresented: $showingAddStoryScreen) { PromptEditorView() }
                .sheet(isPresented: $showingLoginScreen) { LoginView() }
                .sheet(isPresented: $showingSearchScreen) { SearchView() }
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
