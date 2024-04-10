//
//  SongPage.swift
//  MusicApp
//
//  Created by AKSHAY VAIDYA on 05/04/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct SongPage:View {
    
    let song:SongData?
    @State var isnavigate = false
    @ObservedObject var viewmodel = SongViewModel()
    @State var selectedindex = 0
    @State var songlist = [SongData]()
    
    var body: some View {
        VStack(spacing: 0){
            
            if isnavigate{
                
                NavigationLink("", destination: PlayerPage(song: song, viewmodel:viewmodel, index: selectedindex, songlist: songlist).navigationBarBackButtonHidden().navigationBarItems(leading: BackButton()), isActive: $isnavigate)
                   
                    .frame(height: 0)
                    .hidden()
            }
            
            Button(action: {
                
             
                if let song = song{
                    viewmodel.selectedindex = songlist.firstIndex(of: song) ?? 0
                    
                }
                isnavigate = true
            }, label: {
                
                
        
            HStack(spacing: 16){
                //  if URL(string: "https://cms.samespace.com/assets/\(song.cover ?? "")") != nil {
                KFImage(URL(string: "\(Network.base_url)/assets/\(song?.cover ?? "")"))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                //                    }
                //                    else{
                //                        Image("ic_icon")
                //                            .resizable()
                //                            .frame(width: 50, height: 50)
                //
                //                    }
                VStack(alignment: .leading,spacing: 6){
                    
                    Text(song?.name ?? "")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(song?.artist ?? "")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.gray)
                    
                }
                
                Spacer()
                
            }
            })
        }
    }
}
