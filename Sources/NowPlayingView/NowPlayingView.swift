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
    @ObservedObject private var controller:MusicPlayingController
    @State private var expanded = false
    @State private var showsQueue = false
    @State private var gestureOffset:CGFloat = 0.0
    @State private var offset:CGFloat = 0.0
    private var safeArea = UIApplication.shared.windows.first?.safeAreaInsets
    private var height = UIScreen.main.bounds.height < UIScreen.main.bounds.width ? UIScreen.main.bounds.height*0.5 : UIScreen.main.bounds.width*0.8
    public init(controller:MusicPlayingController = MusicPlayer.shared) {
        self.controller = controller
    }
    public var body: some View {
        VStack{
            if expanded {
                Capsule().fill(Color.gray).frame(width: expanded ? 60 : 0, height: expanded ? 5 : 0).opacity(expanded ? 1 : 0).padding(.top,expanded ? safeArea?.top : 0)
                    .padding(.vertical,expanded ? 30 : 0).onTapGesture {
                        withAnimation(.spring()) {
                            self.expanded.toggle()
                        }
                    }
            }
            if self.expanded && self.showsQueue {
                QueueView(controller:controller)
            }else {
                self.nowPlaying
            }
            if expanded {
                bottomControls
            }
        }.padding(.horizontal).frame(maxHeight: expanded ? .infinity : 80).onTapGesture {
            withAnimation(.spring()) {
                self.expanded = true
            }
        }.background(BlurView().gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:))).onTapGesture {
            if !self.expanded {
                withAnimation(.spring()) {
                    self.expanded.toggle()
                }
            }
        }).cornerRadius(expanded ? 30 : 0).offset(y: self.expanded ? 0 : self.offset).offset(y: gestureOffset).gesture(DragGesture().onEnded(onEnded(value:)).onChanged(onChanged(value:))).ignoresSafeArea()
    }
    var nowPlaying: some View {
        VStack {
            HStack(spacing: 15){
                SongImageView(item:self.controller.nowPlayingItem,expanded: self.$expanded, height: self.height)
                if !expanded {
                    self.smallView
                }
            }
            VStack{
                if expanded { Spacer() }
                HStack{
                    if expanded {
                        VStack(alignment: .leading){
                            Text(self.controller.nowPlayingItem != nil ? self.controller.nowPlayingItem!.title ?? "No Title" : "Not Playing").font(.callout).fontWeight(.bold)
                            Text(self.controller.nowPlayingItem != nil ? self.controller.nowPlayingItem!.artist ?? "-" : "").font(.callout)
                        }.matchedGeometryEffect(id: "titleAndArtist", in: animation)
                    }
                }.padding()
                if expanded{
                    self.largeControls
                }
                if expanded { Spacer() }
            }.frame(height: expanded ? nil : 0).opacity(expanded ? 1 : 0)
        }
    }
    var smallView: some View {
        HStack{
            VStack(alignment: .leading){
                Text(self.controller.nowPlayingItem != nil ? self.controller.nowPlayingItem!.title ?? "No Title" : "Not Playing").font(.callout).fontWeight(.bold)
                Text(self.controller.nowPlayingItem != nil ? self.controller.nowPlayingItem!.artist ?? "-" : "").font(.callout)
            }.matchedGeometryEffect(id: "titleAndArtist", in: animation)
            Spacer()
            Button(action: {
                self.controller.toggleAction(action: (self.controller.playBackState == .playing) ?  .pause : .play)
            }, label: {
                Image(systemName: (self.controller.playBackState == .playing) ? "pause.fill" : "play.fill").font(.title).foregroundColor(.primary).padding(.vertical).padding(.leading)
            })
            Button(action: {
                self.controller.toggleAction(action: .next)
            }, label: {
                Image(systemName: "forward.fill").font(.headline).foregroundColor(.primary).padding(.vertical).padding(.trailing)
            })
        }
    }
    var largeControls: some View {
        HStack{
            Spacer()
            Button(action: {
                self.controller.toggleAction(action: .previous)
            }, label: {
                Image(systemName: "backward.fill").font(.title).foregroundColor(.primary)
            })
            Spacer()
            Button(action: {
                self.controller.toggleAction(action: (self.controller.playBackState == .playing) ?  .pause : .play)
            }, label: {
                Image(systemName: (self.controller.playBackState == .playing) ? "pause.fill" : "play.fill").font(.largeTitle).foregroundColor(.primary)
            })
            Spacer()
            Button(action: {
                self.controller.toggleAction(action: .next)
            }, label: {
                Image(systemName: "forward.fill").font(.title).foregroundColor(.primary)
            })
            Spacer()
        }.padding()
    }
    var bottomControls: some View {
        HStack {
                VStack{
                    MPVolumeViewRepresentable().frame(width: 50, height: 50, alignment: .center).foregroundColor(.primary).padding(.bottom,-20)
                    Text("airplay").foregroundColor(.primary)
                }.padding(.bottom)
            Spacer()
            Button(action: {
                self.showsQueue.toggle()
            }, label: {
                VStack{
                    Image(systemName: self.showsQueue ? "xmark" : "list.bullet").font(.title).foregroundColor(.primary)
                    Text(self.showsQueue ? "" :"queue").foregroundColor(.primary)
                }
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
            if value.translation.height > UIScreen.main.bounds.height / 4 {
                self.expanded = false
                self.showsQueue = false
            }
            self.gestureOffset = 0
        }
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
            NowPlayingView(controller: MusicPlayingController())
        }.edgesIgnoringSafeArea(.bottom)
    }
}

