//
//  MPVolumeViewRepresentable.swift
// 
//
//  Created by Hannes Harnisch on 24.04.20.
//  Copyright © 2020 hannes.harnisch. All rights reserved.
//

import SwiftUI
import MediaPlayer
import AVKit
import UIKit

struct MPVolumeViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> AVRoutePickerView {
        let view = AVRoutePickerView(frame: .zero)
        view.tintColor = UIColor.darkText
        view.activeTintColor = .white
        view.prioritizesVideoDevices = true
        return view
    }
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        
    }
}

struct MPVolumeViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        MPVolumeViewRepresentable()
    }
}
