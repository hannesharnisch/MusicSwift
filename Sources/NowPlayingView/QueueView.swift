//
//  QueueView.swift
//  
//
//  Created by Hannes Harnisch on 22.04.21.
//

import SwiftUI
import MusicSwift
import MediaPlayer

struct QueueView: View {
    @ObservedObject var controller:MusicPlayingController
    var body: some View {
        List {
            ForEach(self.controller.queue,id: \.persistentID) { song in
                HStack {
                    SongImageView(item: song,expanded: .constant(false)).padding(.trailing)
                    VStack(alignment: .leading){
                        Text(song.title ?? "Untitled").font(.callout).fontWeight(.bold)
                        Text(song.artist ?? "-").font(.callout)
                    }
                    Spacer()
                }.padding()
            }
        }
    }
}

struct SongImageView: View {
    var item:MPMediaItem?
    @Binding var expanded:Bool
    var height:CGFloat = 55
    var body: some View {
        VStack {
            if self.item?.artwork?.image(at: CGSize(width: 1,height: 1)) != nil {
                Image(uiImage: (self.item?.artwork?.image(at: CGSize(width: 80,height: 80))!)!).resizable().aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: expanded ? 15 : 5)).frame(width: expanded ? height : 55, height: expanded ? height : 55)
            } else {
                Image(systemName: "music.note").resizable().aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: expanded ? 15 : 5)).frame(width: expanded ? height : 55, height: expanded ? height : 55)
            }
        }
    }
}

struct QueueView_Previews: PreviewProvider {
    static var previews: some View {
        QueueView(controller: MusicPlayingController())
    }
}
