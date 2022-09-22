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
    
    var currentView: LoadingState = .library
    @State private var isShowingAccountScreen = false
    @State private var isShowingLoginScreen = false
    @State private var isShowingPromptEditorScreen = false
    @State private var isShowingSearchScreen = false
    
    @State private var image: Image = Image("noImagePlaceholder")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        // initial view
        NavigationView {
            ContentView(currentView: currentView) //, hadLaunched: $hadLaunched
                .toolbar {
                    ItemsToolbar(showingPromptEditorScreen: $isShowingPromptEditorScreen, showingLoginScreen: $isShowingLoginScreen, showingSearchScreen: $isShowingSearchScreen)
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        NavigationLink(destination: StoryEditorView()) {
//                            Label("New Story", systemImage: "square.and.pencil")
//                        }
//
//                        Menu {
//                            Button { // this belongs with create a story view
//                                showingAddStoryScreen.toggle()
//                            } label: {
//                                Label("Prompt Editor", systemImage: "doc.badge.gearshape")
//                            }
//
//                            Button {
//                                showingLoginScreen.toggle()
//                            } label: {
//                                Label("Login", systemImage: "lanyardcard")
//                            }
//
//                            Button {
//        //                        showingImagePicker.toggle()
//                            } label: {
//                                Text("Images")
//                                Image(systemName: "arrow.up.and.down.circle")
//                            }
//                        } label: {
//                             Image(systemName: "gearshape.2")
//                        }
//                    }
                }
        //        .onChange(of: inputImage) { _ in loadImage() }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 45, height: 45)
                            .padding([.trailing], 25)
                        Button {
                            isShowingSearchScreen.toggle()
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
                .sheet(isPresented: $isShowingPromptEditorScreen) { PromptEditorView() }
                .sheet(isPresented: $isShowingLoginScreen) { LoginView() }
                .sheet(isPresented: $isShowingSearchScreen) { SearchView() }
        //        .sheet(isPresented: $showingImagePicker) { ImagePicker(image: $inputImage) }
                }
    }
    
    /*
     A method we can call when that property changes. Remember, we can’t use a plain property
     observer here because Swift will ignore changes to the binding, so instead we’ll write a
     method that checks whether inputImage has a value, and if it does uses it to assign a new
     Image view to the image property.
     */
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
//    }
}

//struct MainView_Previews: PreviewProvider {
//    @State private var hadLaunched = UserDefaults.standard.bool(forKey: "hadLaunched")
//    
//    static var previews: some View {
//        MainView(hadLaunched: hadLaunched)
//            .environmentObject(TextGenerationStore())
//    }
//}
