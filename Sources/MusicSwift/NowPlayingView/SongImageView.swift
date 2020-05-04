//
//  SongImageView.swift
//  PartyCollaborate2
//
//  Created by Hannes Harnisch on 28.03.20.
//  Copyright © 2020 Hannes Harnisch. All rights reserved.
//

import SwiftUI

#if os(iOS)
public struct SongImageView: View {
    public @Binding var percentage:CGFloat
    public var songImage:UIImage?
    public var body: some View {
        ZStack {
            if songImage == nil{
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: (((percentage/100)*200)+50), height: (((percentage/100)*200)+50))
                    .cornerRadius((((percentage/100)*5)+5))
                    .shadow(radius: (((percentage/100)*15)+5))
                Image(systemName: "music.note")
                    .foregroundColor(Color.secondary)
                    .padding(20)
                    .colorInvert()
            }else{
                Image(uiImage: songImage!).resizable()
                    .frame(width: (((percentage/100)*200)+50), height: (((percentage/100)*200)+50))
                    .cornerRadius((((percentage/100)*5)+5))
                    .shadow(radius: (((percentage/100)*15)+5))
                    .scaledToFill()
            }
        }
    }
}
#endif
