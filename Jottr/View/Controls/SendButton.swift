//
//  CustomButton.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/21/22.
//

import Foundation
import SwiftUI

struct SendButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}