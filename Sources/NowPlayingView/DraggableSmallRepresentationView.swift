//
//  DraggableSmallRepresentationView.swift
//  PartyCollaborate2
//
//  Created by Hannes Harnisch on 29.03.20.
//  Copyright © 2020 Hannes Harnisch. All rights reserved.
//
#if !os(macOS)
import SwiftUI
struct DraggableSmallRepresentationView<T:View,L:View,S:View>: View {
    var smallContent:T
    var largeContent:L
    var content:S
    @GestureState private var dragOffset = CGSize.zero
    @Binding var percentage:CGFloat
    init(percentage:Binding<CGFloat>,smallContent:() -> T,largeContent:() -> L,content: () -> S){
        self.content = content()
        self.smallContent  = smallContent()
        self.largeContent  = largeContent()
        self._percentage   = percentage
    }
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            if self.percentage != 0{
                HStack{
                    Spacer()
                    Image(systemName: "minus").resizable().foregroundColor(Color(UIColor.lightGray)).frame(width:40,height:6).padding([.bottom,.horizontal],20).padding(.top, 3)
                    Spacer()
                }.contentShape(Rectangle()).onTapGesture {
                        self.percentage = 0
                }.gesture(
                    DragGesture()
                        .updating(self.$dragOffset, body: { (value, state, transaction) in
                        state = value.translation
                    })
                    .onEnded({ value in
                        if (CGFloat(value.translation.height)*2 >= UIScreen.main.bounds.height/2){
                        self.percentage = 0
                    }else{
                        self.percentage = 100
                    }
                }))
                    Spacer()
            }
            HStack(alignment:.center){
                self.content
                if self.percentage == 0{
                    self.smallContent
                }
            }.padding(.bottom, 3).padding(.horizontal, 5).padding(.top, 6).gesture(
                DragGesture()
                    .updating(self.$dragOffset, body: { (value, state, transaction) in
                    state = value.translation
                })
                .onEnded({ value in
                    if (CGFloat(value.translation.height)*2 >= UIScreen.main.bounds.height/2){
                    self.percentage = 0
                }else{
                    self.percentage = 100
                }
            })).onTapGesture {
                if self.percentage == 0{
                    self.percentage = 100
                }
            }
            if self.percentage != 0{
                Spacer()
                self.largeContent.padding(.bottom,25)
            }
            Spacer()
        }.padding(6).frame(maxWidth: UIScreen.main.bounds.width).frame(height: (75 + (((self.percentage/100) * (UIScreen.main.bounds.height - 180)) - CGFloat(self.dragOffset.height)))).background(Blur().onTapGesture {
            if self.percentage == 0{
                self.percentage = 100
            }
        }.gesture(
            DragGesture()
                .updating(self.$dragOffset, body: { (value, state, transaction) in
                state = value.translation
            })
            .onEnded({ value in
                if (CGFloat(value.translation.height)*2 >= UIScreen.main.bounds.height/2){
                self.percentage = 0
            }else{
                self.percentage = 100
            }
        }))).cornerRadius(self.percentage != 0 ? 20 : 0).offset(y: self.percentage == 0 ? 0 : 20).shadow(radius: 10).animation(.linear)
    }
}
#endif
