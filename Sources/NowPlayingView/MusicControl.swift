//
//  MusicControl.swift
//  PartyCollaborate2
//
//  Created by Hannes Harnisch on 28.03.20.
//  Copyright © 2020 Hannes Harnisch. All rights reserved.
//
#if os(iOS)
import SwiftUI
import MusicSwift

public struct MusicControlLarge: View {
    @Binding var nowPlaying:Song?
    @Binding var enabled:Bool
    @Binding var playing:Bool
    @Binding var current:CGFloat
    @Binding var total:CGFloat
    var onPlayPause:(Bool) -> ()
    var onBackward:() ->()
    var onForward:() -> ()
    
   public  init(playing:Binding<Bool>,nowPlaying:Binding<Song?>,enabled:Binding<Bool>,onPlayPause:@escaping(Bool) -> (),onForward:@escaping() -> (),onBackward:@escaping () -> ()){
        self._playing = playing
        self._nowPlaying = nowPlaying
        self._enabled = enabled
        self.onPlayPause = onPlayPause
        self.onBackward = onBackward
        self.onForward = onForward
        self._current = .constant(0.0)
        self._total = .constant(0.0)
    }
    public init(playing:Binding<Bool>,nowPlaying:Binding<Song?>,current:Binding<CGFloat>,total:Binding<CGFloat>,enabled:Binding<Bool>,onPlayPause:@escaping(Bool) -> (),onForward:@escaping() -> (),onBackward:@escaping () -> ()){
        self._playing = playing
        self._nowPlaying = nowPlaying
        self._enabled = enabled
        self.onPlayPause = onPlayPause
        self.onBackward = onBackward
        self.onForward = onForward
        self._current = current
        self._total = total
    }
    public var body: some View {
        Group{
            if self.total != 0.0 {
                MusikSlider(current: $current,total:$total,action:{ value in
                    print(value)
                }).disabled(enabled).padding(.horizontal)
            }
            if (self.nowPlaying != nil){
                VStack(alignment:.leading){
                    Text(self.nowPlaying?.title ?? "").padding(.horizontal)
                    Text(self.nowPlaying?.interpret ?? "").padding(.horizontal).font(.caption)
                }
            }else{
                Text("Not Playing").padding()
            }
            HStack{
                Spacer()
                Button(action: {
                    self.onBackward()
                }) {
                    Image(systemName: "backward.fill").resizable().scaledToFit().frame(width:40,height:40)
                }.padding().disabled(!enabled).foregroundColor(!enabled ? .gray : .primary)
                Spacer()
                Button(action: {
                    self.playing.toggle()
                    self.onPlayPause(self.playing)
                }) {
                    Image(systemName: (self.playing) ? "pause.fill":"play.fill").resizable().scaledToFit().frame(width:40,height:40).foregroundColor(!enabled ? .gray : .primary)
                }.padding().disabled(!enabled)
                Spacer()
                Button(action: {
                    self.onForward()
                }) {
                    Image(systemName: "forward.fill").resizable().scaledToFit().frame(width:40,height:40).foregroundColor(!enabled ? .gray : .primary)
                    }.padding().disabled(!enabled)
                Spacer()
            }
        }.padding()
    }
}
public struct MusicControlSmall: View{
    @Binding var nowPlaying:Song?
    @Binding var enabled:Bool
    @Binding var playing:Bool
    var onPlayPause:(Bool) -> ()
    var onForward:() -> ()
    
    public init(playing:Binding<Bool>,nowPlaying:Binding<Song?>,enabled:Binding<Bool>,onPlayPause:@escaping(Bool) -> (),onForward:@escaping() -> ()){
        self._playing = playing
        self._nowPlaying = nowPlaying
        self._enabled = enabled
        self.onPlayPause = onPlayPause
        self.onForward = onForward
    }
    public var body: some View {
        Group{
            if (self.nowPlaying != nil){
                    VStack(alignment:.leading){
                        Text(self.nowPlaying?.title ?? "").padding(.leading)
                        Text(self.nowPlaying?.interpret ?? "").padding(.leading).font(.caption)
                    }
                }else{
                    Text("Not Playing").padding(.leading)
                }
            Spacer()
                Button(action: {
                    self.playing.toggle()
                    self.onPlayPause(self.playing)
                }) {
                    Image(systemName: (self.playing ) ? "pause.fill":"play.fill").resizable().scaledToFit().frame(width:20,height:20).padding(.vertical).padding(.leading).foregroundColor(!enabled ? .gray : .primary)
                }.disabled(!enabled)
                Button(action: {
                    print("Action")
                    self.onForward()
                }) {
                    Image(systemName: "forward.fill").resizable().scaledToFit().frame(width:20,height:20).padding(.vertical).padding(.trailing).foregroundColor(!enabled ? .gray : .primary)
                }.disabled(!enabled)
        }
    }
}
#endif
