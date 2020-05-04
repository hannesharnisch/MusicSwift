//
//  MusikSlider.swift
//  PartyCollaborate2
//
//  Created by Hannes Harnisch on 28.03.20.
//  Copyright © 2020 Hannes Harnisch. All rights reserved.
//

import SwiftUI
#if os(iOS)
struct MusikSlider: View {
    @Binding var current:CGFloat
    @Binding var total:CGFloat
    @GestureState var dragOffset = CGSize.zero
    @State var newPosition:CGFloat?
    @State var hasTouchbegun = false
    var frame = ((UIScreen.main.bounds.width-40) > 600 ? 600 :  UIScreen.main.bounds.width)
    var action:(CGFloat) ->()
    var body: some View {
        VStack{
            ZStack(alignment: .leading){
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: frame - 40, height: 2)
                    .cornerRadius(1)
                    .shadow(radius: 5)
                    .padding(.vertical)
                Rectangle()
                    .fill(Color.white)
                    .frame(width: (((self.dragOffset != CGSize.zero ? self.current + self.dragOffset.width :current)/total) * (frame - 40)), height: 2)
                    .cornerRadius(1)
                    .padding(.vertical)
                .background(Circle()
                    .fill(Color.white)
                    .frame(width:10,height:10)
                    .position(x: (((self.dragOffset != CGSize.zero ? self.current + self.dragOffset.width :current
                    )/total) * (frame - 40)),y: 17)
                )
            }
            HStack{
                Text("\(Int((current).rounded())/60):\(String(format: "%02d", Int((current).rounded())%60))").font(.caption).transition(.opacity).animation(.none).padding(.leading, UIScreen.main.bounds.width/2 - frame/2)
                Spacer()
                Text("-\(Int((total-current).rounded())/60):\(String(format: "%02d",Int((total-current).rounded())%60))").font(.caption).transition(.opacity).animation(.none).padding(.trailing, UIScreen.main.bounds.width/2 - frame/2)
            }
        }.gesture(DragGesture()
            .updating($dragOffset, body: { (value, state, transaction) in
            state = value.translation
                print("UPDATED")
            })
            .onEnded({ (value) in
                print("MOVE")
                self.action(CGFloat(self.dragOffset.width))
            })
        )
    }
}
#endif
