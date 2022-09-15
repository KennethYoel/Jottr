/*
 ActivityViewController.swift
 Jottr

 Created by Kenneth Gutierrez on 9/13/22.

 For wrapping a UIActivityViewController in SwiftUI View so we can gain access to UIKit’s classes
 code samples from https://swifttom.com/2020/02/06/how-to-share-content-in-your-app-using-uiactivityviewcontroller-in-swiftui/
 & https://www.hackingwithswift.com/books/ios-swiftui/wrapping-a-uiviewcontroller-in-a-swiftui-view
 */

import PhotosUI
import SwiftUI

// sharing content in Jottr using a UIViewControllerRepresentable
struct ActivityViewController: UIViewControllerRepresentable {
    /*
     itemsToShare is for our content that we want to pass to other services and
     servicesToShareItem is to get a list of service we can uses to share our content
     */
    var itemsToShare: [Any]
    var servicesToShareItem: [UIActivity]? = nil
    
    // where we sent the context to UIActivityViewController so it can be displayed in SwiftUI
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: servicesToShareItem)
        
        return controller
    }
    
    // to keep the Controller up to date with any changes
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

// saving an image to the user's photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    // a nested class for SwiftUI’s coordinators whcih are designed to act as delegates for UIKit view controllers.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    /*
     We aren’t going to be using updateUIViewController(), so deleted the “code” line
     from there so that the method is empty.
     */
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    // the bridge between UIKit and SwiftUI, allowing both to communicate to each other
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /*
     A hack to make Xcode write the two methods we actually need, and in fact those two methods above
     are actually enough for Swift to figure out the view controller type so you can delete the typealias line.
     */
//    typealias UIViewControllerType = PHPickerViewController
}
