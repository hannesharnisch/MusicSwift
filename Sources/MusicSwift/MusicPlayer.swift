//
//  MusicPlayer.swift
//  
//
//  Created by Hannes Harnisch on 04.05.20.
//
#if os(iOS)
import Foundation
import MediaPlayer
import Combine


public final class MusicPlayer: MusicPlayingController {
    public static let shared = MusicPlayer()
    private var musicPlayer = MPMusicPlayerController.systemMusicPlayer
    private var playHeadTimer:Timer? = nil {
        willSet {
            playHeadTimer?.invalidate()
        }
    }
    override init() {
        super.init()
        musicPlayer.beginGeneratingPlaybackNotifications()
        self.nowPlayingItem = self.musicPlayer.nowPlayingItem
        self.playBackState = self.musicPlayer.playbackState
        if self.musicPlayer.nowPlayingItem?.playbackDuration != nil {
            self.currentPlaybackTime = self.musicPlayer.currentPlaybackTime/(self.musicPlayer.nowPlayingItem!.playbackDuration)
        }
        self.queue = []
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendNowPlayingChange(_:)), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendChangedQueue(_:)), name: .MPMusicPlayerControllerQueueDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendPlaybackState(_:)), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        musicPlayer.repeatMode = .all
        musicPlayer.shuffleMode = .off
    }
    @objc private func sendNowPlayingChange(_ notification: Notification){
        self.nowPlayingItem = self.musicPlayer.nowPlayingItem
    }
    @objc private func sendChangedQueue(_ notification: Notification){
        if self.updateQueue() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                _ = self.updateQueue()
            }
        }
    }
    @objc private func sendPlaybackState(_ notification: Notification){
        self.playBackState = self.musicPlayer.playbackState
    }
    override public func toggleAction(action: MusicPlayingController.Action) {
        switch action{
        case .next:
            self.musicPlayer.skipToNextItem()
        case .previous:
            self.musicPlayer.skipToPreviousItem()
        case .play:
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.play()
        case .pause:
            self.musicPlayer.pause()
        }
    }
}
extension MusicPlayer {
    public func subscribeToPlayHead(){
        playHeadTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.playHeadChangeTimer), userInfo: nil, repeats: true)
    }
    public func cancelPlayHeadSubscription(){
        playHeadTimer?.invalidate()
        playHeadTimer = nil
    }
    @objc func playHeadChangeTimer(){
        if Double(musicPlayer.currentPlaybackTime)/(self.musicPlayer.nowPlayingItem?.playbackDuration ?? 1) != self.currentPlaybackTime || self.currentPlaybackTime == nil {
            if self.musicPlayer.nowPlayingItem?.playbackDuration != nil {
                self.currentPlaybackTime = Double(musicPlayer.currentPlaybackTime)/(self.musicPlayer.nowPlayingItem!.playbackDuration)
            }else{
                self.currentPlaybackTime = nil
            }
            
        }
    }
}

extension MusicPlayer{
    private func updateQueue() -> Bool {
        guard let queue = self.getCurrentQueue() else{
            return false
        }
        self.queue = queue
        return true
    }
    public func getCurrentQueue() -> [MPMediaItem]?{
        let items = self.queue
        let index = musicPlayer.indexOfNowPlayingItem
        var queue = [MPMediaItem]()
        if items.count == 1{
            queue.append(items[0])
        }else if index >= items.count{
            return nil
        }else{
            if index < items.count - 1 {
                for i in (index + 1..<items.count){
                    queue.append(items[i])
                }
            }
            for a in 0...index{
                queue.append(items[a])
            }
        }
        return queue
    }
}

extension MusicPlayer {
    public func setSongs(queue:MPMediaItemCollection){
        musicPlayer.setQueue(with: queue)
        self.queue =  queue.items
        musicPlayer.prepareToPlay()
    }
    public func setSongs(queue:[MPMediaItem]){
        self.setSongs(queue: MPMediaItemCollection(items: queue))
    }
    public func addSongsToQueue(songs: MPMediaItemCollection){
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: songs)
        musicPlayer.append(descriptor)
        var newQueue = self.queue
        newQueue.append(contentsOf: songs.items)
        self.queue = newQueue
    }
    public func addSongsToQueue(songs:[MPMediaItem]){
        self.addSongsToQueue(songs: MPMediaItemCollection(items: songs))
    }
    public func prependSongsToQueue(songs: MPMediaItemCollection){
        let descriptor = MPMusicPlayerMediaItemQueueDescriptor(itemCollection: songs)
        musicPlayer.prepend(descriptor)
        self.queue = self.insertAtNowPlayingItem(queue: self.queue, songs: songs.items)
    }
    public func prependSongsToQueue(songs:[MPMediaItem]){
        self.prependSongsToQueue(songs: MPMediaItemCollection(items: songs))
    }
    private func insertAtNowPlayingItem(queue:[MPMediaItem],songs:[MPMediaItem]) -> [MPMediaItem]{
        let index = musicPlayer.indexOfNowPlayingItem
        var newQueue = [MPMediaItem]()
        for i in (0...index){
            newQueue.append(queue[i])
        }
        newQueue.append(contentsOf: songs)
        if index != queue.count{
            for a in (index + 1)..<queue.count{
                newQueue.append(queue[a])
            }
        }
        return newQueue
    }
    public func removeSongFromQueue(song:MPMediaItem){
        print("REMOVing \(song.title)")
        guard var queue = getCurrentQueue() else{
            print("ERROR loading QUEUE")
            return
        }
        let element = queue.removeLast()
        queue.insert(element, at: 0)
        queue.removeAll { (song1) -> Bool in
            return song1.playbackStoreID == song.playbackStoreID
        }
        let state = musicPlayer.playbackState
        let playbackTime = musicPlayer.currentPlaybackTime
        let isNowPlayingBeeingDeleted = musicPlayer.nowPlayingItem!.playbackStoreID == song.playbackStoreID
        self.queue = queue
        musicPlayer.prepareToPlay()
        musicPlayer.setQueue(with: self.queueDescriptorFrom(songs: queue))
        musicPlayer.prepareToPlay()
        if state == .playing{
            musicPlayer.play()
        }
        if !isNowPlayingBeeingDeleted{
            setNowPlayingPosition(position: playbackTime)
        }
    }
    public func setNowPlayingPosition(position:TimeInterval){
        guard musicPlayer.nowPlayingItem?.playbackDuration ?? 0.0 > position else{
            return
        }
        musicPlayer.currentPlaybackTime = position
    }
    public func queueDescriptorFrom(songs:[MPMediaItem]) -> MPMusicPlayerStoreQueueDescriptor{
        var ids = [String]()
        for song in songs{
            ids.append(song.playbackStoreID)
        }
        return MPMusicPlayerStoreQueueDescriptor(storeIDs: ids)
    }
}

public class MusicPlayingController: ObservableObject {
    @Published public var nowPlayingItem:MPMediaItem? = nil
    @Published public var playBackState:MPMusicPlaybackState = .paused
    @Published public var queue:[MPMediaItem] = []
    @Published public var currentPlaybackTime:Double? = nil
    public enum Action{
        case play,pause,next,previous
    }
    public func toggleAction(action:MusicPlayingController.Action) {
        fatalError("Please override toggleAction")
    }
}
#endif
