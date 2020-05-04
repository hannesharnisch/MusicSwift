//
//  NowPlayingView.swift
//  PartyCollaborate2
//
//  Created by Hannes Harnisch on 27.03.20.
//  Copyright © 2020 Hannes Harnisch. All rights reserved.
//
#if os(iOS)
import SwiftUI
import Foundation
import MusicSwift

public struct NowPlayingInfoView<T:MusicPlayerActionEnabled>: View {
    @Binding var showMusikPlaying:CGFloat
    var controller:T?
    @Binding var nowPlaying:Song?
    @Binding var current:CGFloat
    @Binding var total:CGFloat
    @Binding var enabled:Bool
    @Binding var playing:Bool
    public init(showMusikPlaying:Binding<CGFloat>,controller:T?,nowPlaying:Binding<Song?>,currentPlayBackTime: Binding<CGFloat>,totalPlayBackTime:Binding<CGFloat>,enabled:Binding<Bool>,playing:Binding<Bool>){
        self._showMusikPlaying = showMusikPlaying
        self.controller = controller
        self._nowPlaying = nowPlaying
        self._current = currentPlayBackTime
        self._total = totalPlayBackTime
        self._enabled = enabled
        self._playing = playing
    }
    public var body: some View {
        GeometryReader{ geometry in
        VStack{
        Spacer()
        ZStack{
            DraggableSmallRepresentationView(percentage: self.$showMusikPlaying, smallContent: {
                MusicControlSmall(playing: self.$playing, nowPlaying: self.$nowPlaying, enabled: self.$enabled, onPlayPause: { (play) in
                    if play{
                        self.controller?.toggleAction(action: .play)
                    }else{
                        self.controller?.toggleAction(action: .pause)
                    }
                }, onForward: {
                    self.controller?.toggleAction(action: .next)
                }).onDisappear {
                    self.controller?.changedStateTo(large: true)
                }
            }, largeContent: {
                VStack{
                    MusicControlLarge(playing: self.$playing, nowPlaying: self.$nowPlaying,current: self.$current,total: self.$total, enabled: self.$enabled, onPlayPause: { (play) in
                   if play{
                    self.controller?.toggleAction(action: .play)
                    }else{
                    self.controller?.toggleAction(action: .pause)
                    }
                }, onForward: {
                    self.controller?.toggleAction(action: .next)
                }) {
                    self.controller?.toggleAction(action: .previous)
                }.onDisappear {
                    self.controller?.changedStateTo(large: false)
                }
                    if self.enabled{
                        MPVolumeViewRepresentable()
                    }
                    Spacer()
                }
            }) {
                VStack{
                    Spacer()
                    SongImageView(percentage: self.$showMusikPlaying, songImage: self.nowPlaying?.getImage())
                    Spacer()
                }
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
        }
        }
        }
    }
}
public protocol MusicPlayerActionEnabled {
    func toggleAction(action:MusicPlayerAction)
    func changedStateTo(large:Bool)
}
public enum MusicPlayerAction{
    case play
    case pause
    case next
    case previous
}

public struct Blur: UIViewRepresentable {
    public var effect: UIVisualEffect = UIBlurEffect(style: .systemThinMaterial)
    public init(){
        
    }
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    public func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
#endif
