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
    private var controller:MusicPlayerActionEnabled
    @Binding private var offset:CGFloat
    @Binding private var playing:Bool
    @Binding private var song:Song?
    @State private var expanded = false
    @State private var gestureOffset:CGFloat = 0.0
    private var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    private var height = min(UIScreen.main.bounds.height * 0.8 , UIScreen.main.bounds.width * 0.8)
    public init(controller:MusicPlayerActionEnabled,nowPlaying:Binding<Song?>, playing:Binding<Bool>){
        self.init(controller: controller, nowPlaying: nowPlaying, playing: playing, offset: .constant(0.0))
    }
    public init(controller:MusicPlayerActionEnabled,nowPlaying:Binding<Song?>, playing:Binding<Bool>,offset:Binding<CGFloat>){
        self.controller = controller
        self._offset = offset
        self._playing = playing
        self._song = nowPlaying
        
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
                if song?.getImage() != nil {
                    Image(uiImage: song!.getImage()!).resizable().aspectRatio(contentMode: .fill)
                    .frame(width: expanded ? height : 55, height: expanded ? height : 55)
                    .cornerRadius(15)
                } else {
                    Image(systemName: "music.note").resizable().aspectRatio(contentMode: .fit)
                        .frame(width: expanded ? height : 55, height: expanded ? height : 55)
                        .cornerRadius(15)
                }
                if !expanded {
                    VStack(alignment: .leading){
                        Text(song != nil ? song!.title:"Not Playing").font(.callout).fontWeight(.bold)
                        Text(song != nil ? song!.interpret : "").font(.callout)
                    }.matchedGeometryEffect(id: "titleAndArtist", in: animation)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: self.playing ? "pause.fill" : "play.fill").font(.headline).foregroundColor(.primary)
                    })
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "forward.fill").font(.headline).foregroundColor(.primary)
                    })
                }
            }
            if expanded { Spacer() }
            VStack{
                HStack{
                    if expanded {
                        VStack(alignment: .leading){
                            Text(song != nil ? song!.title:"Not Playing").font(.callout).fontWeight(.bold)
                            Text(song != nil ? song!.interpret : "").font(.callout)
                        }.matchedGeometryEffect(id: "titleAndArtist", in: animation)
                    }
                }.padding()
                if expanded{
                    HStack{
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "backward.fill").font(.title).foregroundColor(.primary)
                        })
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: self.playing ? "pause.fill" : "play.fill").font(.largeTitle).foregroundColor(.primary)
                        })
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "forward.fill").font(.title).foregroundColor(.primary)
                        })
                    }.padding()
                }
            }.frame(height: expanded ? nil : 0).opacity(expanded ? 1 : 0)
            if expanded { Spacer() }
        }.padding(.horizontal).frame(maxHeight: expanded ? .infinity : 80).onTapGesture {
            withAnimation(.spring()) {
                self.expanded.toggle()
            }
        }.background(BlurView()).cornerRadius(expanded ? 30 : 0).offset(y: expanded ? 0 : offset).offset(y: gestureOffset).gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:))).ignoresSafeArea()
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
public protocol MusicPlayerActionEnabled{
    func toggleAction(action:NowPlayingView.Action)
    func changeStateTo(state:NowPlayingView.Condition)
}
