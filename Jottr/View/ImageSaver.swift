//
//  ImageSaver.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/14/22.
//

import UIKit

class ImageSaver: NSObject {
    // to write an image to the photo library and read the response
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Saved finished!")
    }
}
