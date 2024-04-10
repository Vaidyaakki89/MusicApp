//
//  Foryoupage.swift
//  MusicApp
//
//  Created by AKSHAY VAIDYA on 04/04/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct Foryoupage:View {
    @ObservedObject var viewmodel = SongViewModel()
    
    var body: some View {
        VStack{
            
            List(viewmodel.songlist, id: \.self){song in
                
                SongPage(song: song, viewmodel:viewmodel, songlist:viewmodel.songlist)
                
                    .listRowSeparator(.hidden)
                    
            }.listStyle(.plain)
            
        }
    }
}
