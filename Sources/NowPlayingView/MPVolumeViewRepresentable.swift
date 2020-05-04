//
//  MPVolumeViewRepresentable.swift
//  WeParty
//
//  Created by Hannes Harnisch on 24.04.20.
//  Copyright © 2020 hannes.harnisch. All rights reserved.
//
#if os(iOS)
import SwiftUI
import MediaPlayer
import UIKit

public struct MPVolumeViewRepresentable: UIViewRepresentable {
    public func makeUIView(context: Context) -> MPVolumeView {
        let view = MPVolumeView(frame: .zero)
        view.showsVolumeSlider = false
        return view
    }
    public func updateUIView(_ uiView: MPVolumeView, context: Context) {
        
    }
}

struct MPVolumeViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        MPVolumeViewRepresentable()
    }
}
#endif
