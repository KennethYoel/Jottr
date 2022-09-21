//
//  PopoverView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/20/22.
//

import SwiftUI

enum Explainer {
    case themeExplainer, premiseExplainer
}

struct PopoverTextView: View {
    
    @Binding var mainPopover: Explainer
    
    let themeExplainer: String = """
    Let's start with a theme, which is the central idea or underlying meaning you the writer and the AI explore in your
    literary work.
    
    E.g. "What comes around, goes around."
    
    The theme of a story can be conveyed using characters, setting, dialogue, plot, or a combination of all of these
    elements.
    
    For example in simpler stories, the theme may be a moral tale or message: “When you work hard and persevere, you can
    achieve your goals. Slow and steady wins the race.”
    """
    
    let premiseExplainer = """
    Here we have the premise, which is your entire story condensed to a single sentence
        
    E.g. "Three people tell conflicting versions of a meeting that changed the outcome of World War II."

    Also, you may influence your AI writing style with directions.

    E.g. "Use a very descriptive writing style in 17th century language."
    """
    
    var body: some View {
        if mainPopover == .themeExplainer {
            Text(themeExplainer)
                .padding()
        } else if mainPopover == .premiseExplainer {
            Text(premiseExplainer)
                .padding()
        }
    }
}
