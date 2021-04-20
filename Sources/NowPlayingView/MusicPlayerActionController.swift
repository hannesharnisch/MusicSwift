//
//  File.swift
//  
//
//  Created by Hannes Harnisch on 19.04.21.
//

import Foundation
import MusicSwift
import SwiftUI
import MediaPlayer

@available(iOS 14.0, *)
public protocol MusicPlayerActionEnabled {
    func toggleAction(action:NowPlayingView.Action)
    func changeStateTo(state:NowPlayingView.Condition)
}
@available(iOS 14.0, *)
public class MusicPlayerActionController: ObservableObject {
    @Published var offset:CGFloat = 0.0
    @Published var playing:Bool = false
    @Published var song:Song? = nil
    let musicPlayer = MusicPlayer.shared
    public init(){
        musicPlayer.delegate = self
    }
}
@available(iOS 14.0, *)
extension MusicPlayerActionController:MusicPlayerActionEnabled {
    public func toggleAction(action:NowPlayingView.Action) {
        switch action {
        case .next:
            musicPlayer.foreward()
        case .previous:
            musicPlayer.backward()
        case .play:
            musicPlayer.play()
        case .pause:
            musicPlayer.pause()
        }
    }
    
    public func changeStateTo(state:NowPlayingView.Condition) {
    }
}
@available(iOS 14.0, *)
extension MusicPlayerActionController : MusicPlayerDelegate {
    public func nowPlayingChanged(nowPlaying: MPMediaItem?) {
        DispatchQueue.main.async {
            guard let nowPlaying = nowPlaying else {
                self.song = nil
                return
            }
            self.song = Song(song: nowPlaying)
        }
        
    }
    
    public func queueDidChange(queue: [Song], type: QueueChangeType) {
    }
    
    public func playingStateChanged(state: MPMusicPlaybackState) {
        DispatchQueue.main.async {
            self.playing = state == .playing
        }
    }
    
    public func playHeadPositionChanged(current: Double, total: Double) {
    }
}
