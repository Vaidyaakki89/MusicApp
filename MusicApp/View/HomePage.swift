//
//  HomePage.swift
//  MusicApp
//
//  Created by AKSHAY VAIDYA on 04/04/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct HomePage:View {
    
    @State var isForyou = true
    @State var istoptrack = false
    @ObservedObject var viewmodel = SongViewModel()
    @State var isnavigate = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var totalamount = 0.0
    @State  var downloadAmount = 0.0
    
    var body: some View {
        
        VStack{
          
            NavigationView{
                
                VStack{
                if isForyou{
                    Foryoupage(viewmodel: viewmodel)
                        .padding(.top, 20)
                    
                }
                else{
                    
                    ToptrackPage(viewmodel: viewmodel)
                        .padding(.top, 20)
                }
                
                
                Spacer()
                    
                    if viewmodel.selectedsong != nil{
                        
                        Button(action: {
                           isnavigate = true
                        }, label: {
                            
                            VStack(spacing: 0){
                                
                                if isnavigate{
                                    
                                    NavigationLink("", destination: PlayerPage(song: viewmodel.selectedsong, viewmodel:viewmodel, index: 0, songlist: viewmodel.selectedsonglist).navigationBarBackButtonHidden().navigationBarItems(leading: BackButton()), isActive: $isnavigate)
                                       
                                        .frame(height: 0)
                                        .hidden()
                                }
                        
                                HStack(spacing: 16){
                                    //  if URL(string: "https://cms.samespace.com/assets/\(song.cover ?? "")") != nil {
                                    KFImage(URL(string: "\(Network.base_url)/assets/\(viewmodel.selectedsong?.cover ?? "")"))
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
                                    VStack(alignment: .leading,spacing: 8){
                                        
                                        Text(viewmodel.selectedsong?.name ?? "")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(.white)
                                        //
                                        //                            Text(song?.artist ?? "")
                                        //                                .font(.system(size: 15, weight: .regular))
                                        //                                .foregroundColor(.gray)
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                       
                                        viewmodel.controlPlayer()
                                        
                                        if viewmodel.player.isPlaying{
                                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                        }
                                        
                                    }, label: {
                                        
                                        Image(viewmodel.buttonname)
                                            .resizable()
                                            .frame(width: 35, height: 35,alignment: .center)
                                        
                                        
                                    })
                                }    .onReceive(timer) { _ in
                                    
                         
                                    setTimer()
                                    
                                }
                        }
                            
                        }).padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                    }
                
                HStack(alignment: .top){
                    
                    Button(action: {
                        istoptrack = false
                        isForyou = true
                        
                    }, label: {
                        
                        VStack(spacing: 8){
                            if isForyou
                            {
                                Text("For You")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color.white)
                                Image("circle")
                            }
                            else
                            {
                                Text("For You")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color.gray)
                                // Image("circle")
                            }
                            
                        }.padding(.horizontal, 25)
                        
                    })
                    
                    Button(action: {
                        istoptrack = true
                        isForyou = false
                        
                    }, label: {
                        
                        VStack(spacing: 8){
                            if istoptrack
                            {
                                Text("Top Tracks")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color.white)
                                Image("circle")
                            }
                            else
                            {
                                Text("Top Tracks")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color.gray)
                                // Image("circle")
                            }
                            
                        }.padding(.horizontal, 25)
                        
                    })
                }
                //  .border(.red)
                .padding(.bottom, 18)
                
            }
                .onAppear(){
                    
                    if viewmodel.selectedsong != nil{
                        
                        downloadAmount = viewmodel.player.currentTime
                        
                        totalamount = viewmodel.player.duration
                        
                        if viewmodel.player.isPlaying{
                            
                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                            
                        }
                    }
                }
                .onDisappear(){
                    
                    timer.upstream.connect().cancel()
                }
                
            }
        }
        .onAppear(){
            
            viewmodel.getSonglistapi()
            
          
        }
       
     
//        .onChange(of: viewmodel.player.isPlaying, perform: {_ in
//            
//            print("changed")
//        })
    }
    
    func setTimer(){
        
        print(Int(downloadAmount))
        print(Int(totalamount) - 1)
        
        if !viewmodel.player.isPlaying{
            
            timer.upstream.connect().cancel()
        }
        
        
        if downloadAmount < totalamount {
            downloadAmount = viewmodel.player.currentTime
         //   let c = TimeInterval(downloadAmount)
           
           
            if Int(downloadAmount) == Int(totalamount) - 1{
                
                
                
                if viewmodel.selectedindex == viewmodel.selectedsonglist.count - 1{
                    
                   // viewmodel.player.stop()
                    downloadAmount = 0
                   // totalamount = 0
                  
                  
                    viewmodel.buttonname = "pause"
                    timer.upstream.connect().cancel()
                }
               // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    rightSwipe()
              //  }
            }
        }
        
    }
    
    func rightSwipe(){
        print("index: \(viewmodel.selectedindex)")
        
        if viewmodel.selectedindex < viewmodel.selectedsonglist.count - 1{
            downloadAmount = 0
            viewmodel.selectedindex = viewmodel.selectedindex + 1
            viewmodel.selectedsong = viewmodel.selectedsonglist[viewmodel.selectedindex]
         
            viewmodel.setPlayer(audiourl: viewmodel.selectedsong?.url ?? ""){
                downloadAmount = 0.0
                totalamount = viewmodel.player.duration
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        }
        
    }
}


struct HomePage_preview:PreviewProvider{
    
    static var previews: some View{
        
        HomePage()
    }
    
}
