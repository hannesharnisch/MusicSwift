//
//  SwiftUIView.swift
//  
//
//  Created by Hannes Harnisch on 27.12.20.
//

import SwiftUI
import MusicSwift

@available(iOS 14.0, *)
public struct NowPlayingView: View {
    @Namespace private var animation
    @ObservedObject private var controller:MusicPlayerActionController
    @State private var expanded = false
    @State private var gestureOffset:CGFloat = 0.0
    private var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    private var height = min(UIScreen.main.bounds.height * 0.8 , UIScreen.main.bounds.width * 0.8)
    public init(controller:MusicPlayerActionController = MusicPlayerActionController()) {
        self.controller = controller
    }
    public var body: some View {
        VStack{
            if expanded {
                Capsule().fill(Color.gray).frame(width: expanded ? 60 : 0, height: expanded ? 4 : 0).opacity(expanded ? 1 : 0).padding(.top,expanded ? safeArea?.top : 0)
                    .padding(.vertical,expanded ? 30 : 0).onTapGesture {
                        withAnimation(.spring()) {
                            self.expanded.toggle()
                        }
                    }
            }
            HStack(spacing: 15){
                if self.controller.song?.getImage() != nil {
                    Image(uiImage: self.controller.song!.getImage()!).resizable().aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: expanded ? 15 : 5)).frame(width: expanded ? height : 55, height: expanded ? height : 55)
                } else {
                    Image(systemName: "music.note").resizable().aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: expanded ? 15 : 5)).frame(width: expanded ? height : 55, height: expanded ? height : 55)
                }
                if !expanded {
                    self.smallView
                }
            }
            if expanded { Spacer() }
            VStack{
                HStack{
                    if expanded {
                        VStack(alignment: .leading){
                            Text(self.controller.song != nil ? self.controller.song!.title:"Not Playing").font(.callout).fontWeight(.bold)
                            Text(self.controller.song != nil ? self.controller.song!.interpret : "").font(.callout)
                        }.matchedGeometryEffect(id: "titleAndArtist", in: animation)
                    }
                }.padding()
                if expanded{
                    self.largeControls
                }
            }.frame(height: expanded ? nil : 0).opacity(expanded ? 1 : 0)
            if expanded { Spacer() }
        }.padding(.horizontal).frame(maxHeight: expanded ? .infinity : 80).onTapGesture {
            withAnimation(.spring()) {
                self.expanded.toggle()
            }
        }.background(BlurView().gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:))).onTapGesture {
            if !self.expanded {
                withAnimation(.spring()) {
                    self.expanded.toggle()
                }
            }
        }).cornerRadius(expanded ? 30 : 0).offset(y: self.expanded ? 0 : self.controller.offset).offset(y: gestureOffset).gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:))).ignoresSafeArea()
    }
    var smallView: some View {
        HStack{
            VStack(alignment: .leading){
                Text(self.controller.song != nil ? self.controller.song!.title:"Not Playing").font(.callout).fontWeight(.bold)
                Text(self.controller.song != nil ? self.controller.song!.interpret : "").font(.callout)
            }.matchedGeometryEffect(id: "titleAndArtist", in: animation)
            Spacer()
            Button(action: {
                self.controller.toggleAction(action: self.controller.playing ?  .pause : .play)
            }, label: {
                Image(systemName: self.controller.playing ? "pause.fill" : "play.fill").font(.title).foregroundColor(.primary)
            })
            Button(action: {
                self.controller.toggleAction(action: .next)
            }, label: {
                Image(systemName: "forward.fill").font(.headline).foregroundColor(.primary)
            })
        }
    }
    var largeControls: some View {
        HStack{
            Button(action: {
                self.controller.toggleAction(action: .previous)
            }, label: {
                Image(systemName: "backward.fill").font(.title).foregroundColor(.primary)
            })
            Spacer()
            Button(action: {
                self.controller.toggleAction(action: self.controller.playing ?  .pause : .play)
            }, label: {
                Image(systemName: self.controller.playing ? "pause.fill" : "play.fill").font(.largeTitle).foregroundColor(.primary)
            })
            Spacer()
            Button(action: {
                self.controller.toggleAction(action: .next)
            }, label: {
                Image(systemName: "forward.fill").font(.title).foregroundColor(.primary)
            })
        }.padding()
    }
    private func onChanged(value:DragGesture.Value){
        if value.translation.height > 0 && expanded {
            self.gestureOffset = value.translation.height
        }
    }
    private func onEnded(value:DragGesture.Value){
        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.95, blendDuration: 0.95)) {
            if value.translation.height > UIScreen.main.bounds.height / 3 {
                self.expanded = false
            }
            self.gestureOffset = 0
        }
    }
    public enum Action{
        case play,pause,next,previous
    }
    public enum Condition{
        case large,small
    }
}

@available(iOS 14.0, *)
struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment:.bottom) {
            NavigationView{
                VStack{
                    Spacer()
                    Text("HI")
                    Spacer()
                }.navigationBarTitle("NowPlayingView")
            }.navigationViewStyle(StackNavigationViewStyle())
            NowPlayingView()
        }.edgesIgnoringSafeArea(.bottom)
    }
}

