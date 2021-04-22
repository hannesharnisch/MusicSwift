//
//  BlurView.swift
//  
//
//  Created by Hannes Harnisch on 27.12.20.
//

import Foundation
import SwiftUI
import UIKit

struct BlurView:UIViewRepresentable{
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
