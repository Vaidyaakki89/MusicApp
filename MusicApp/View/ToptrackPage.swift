//
//  ToptrackPage.swift
//  MusicApp
//
//  Created by AKSHAY VAIDYA on 04/04/24.
//

import Foundation
import SwiftUI

struct ToptrackPage:View {
    @ObservedObject var viewmodel = SongViewModel()
    
    var body: some View {
        VStack{
            
            List(viewmodel.toptractlist, id: \.self){song in
                
            SongPage(song: song, viewmodel:viewmodel, songlist:viewmodel.toptractlist)
                
                    .listRowSeparator(.hidden)
                    
            }.listStyle(.plain)
            
        }
    }}
