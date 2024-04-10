//
//  PlayerPage.swift
//  MusicApp
//
//  Created by AKSHAY VAIDYA on 05/04/24.
//

import Foundation
import SwiftUI
import Kingfisher
import AVFoundation

struct PlayerPage:View {
    
   @State var song:SongData?
    
    let screen = UIScreen.main.bounds
    @ObservedObject var viewmodel = SongViewModel()
    let index: Int
    @State var songlist = [SongData]()
    @State var starttime = ""
    @State var endtime = ""
    @State var totalamount = 0.0
    @State  var downloadAmount = 0.0
    @State var firstedge = 0.0
   
  @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
   
        
        VStack(spacing: 0){
            
                ScrollViewReader{ proxy in
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(0..<songlist.count, id: \.self){i in
                           
                                KFImage(URL(string: "\(Network.base_url)/assets/\(songlist[i].cover ?? "")"))
                                    .resizable()
                            .frame(width: screen.width * 0.8, height: screen.height * 0.4)
                            .padding(.horizontal, 5)
                            .gesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
                                   .onEnded { value in
                                       if abs(value.translation.height) < abs(value.translation.width) {
                                           if abs(value.translation.width) > 50.0 {
                                               if value.translation.width < 0 {
                                                 rightSwipe()
                                               } else if value.translation.width > 0 {
                                                leftSwipe()
                                                 
                                               }
                                           }
                                       }
                                   })
                                
                                
                            }
                        .onAppear(){
                        
                            proxy.scrollTo(viewmodel.selectedindex, anchor: .center)
                        }
                        .onChange(of: viewmodel.selectedindex, perform: {_ in
                            
                            proxy.scrollTo(viewmodel.selectedindex, anchor: .center)
                        })
                        }
                 
                    
                    }
                    .padding(.leading, (viewmodel.selectedindex == 0) ? firstedge : 0)
                        .padding(.trailing, (viewmodel.selectedindex == (viewmodel.songlist.count - 1) ? firstedge : 0))
                    .scrollDisabled(true)
                 //   .animation(Animation.linear(duration: 0.1))
                   
            }
            
            Spacer()
            
            Text(song?.name ?? "")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.bottom, 2)
            Text(song?.artist ?? "")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.gray)
                .padding(.bottom, 55)
            
            ProgressView(value: downloadAmount, total: totalamount)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(.white)
                .padding(.bottom, 10)
                .padding(.horizontal, 16)
                .onReceive(timer) { _ in
                    
                   // if viewmodel.player.isPlaying{
                    print(Int(downloadAmount))
                    print(Int(totalamount) - 1)
                    
                    if !viewmodel.player.isPlaying{
                        
                        timer.upstream.connect().cancel()
                    }
                        
                        if downloadAmount < totalamount {
                            downloadAmount = viewmodel.player.currentTime
                            let c = TimeInterval(downloadAmount)
                            starttime = c.stringFromTimeInterval()
                           
                            if Int(downloadAmount) == Int(totalamount) - 1{
                                
                                
                                
                                if viewmodel.selectedindex == songlist.count - 1{
                                    
                               
                                    downloadAmount = 0
                                   // totalamount = 0
                                    let c = TimeInterval(downloadAmount)
                                    starttime = c.stringFromTimeInterval()
                                    viewmodel.buttonname = "pause"
                                    timer.upstream.connect().cancel()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    rightSwipe()
                                }
                            }
                        }
                  //  }
                           }
               
            
            HStack{
                Text(starttime)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
                Spacer()
                Text(endtime)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }.padding(.horizontal, 16)
                .padding(.bottom, 50)
            
            HStack(spacing: 48){
                
                Button(action: {
                 
                  leftSwipe()
                }, label: {
                    
                    Image("left")
                })
                
                Button(action: {
                 
                  
                    viewmodel.controlPlayer()
                    if !viewmodel.player.isPlaying{
                        
                        print(viewmodel.player.currentTime)
                        print(downloadAmount)
                        
                        viewmodel.player.currentTime = downloadAmount
                        timer.upstream.connect().cancel()
                    }else{
                        
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    }
                    
                }, label: {
                   
                    Image(viewmodel.buttonname)
                        .resizable()
                        .frame(width: 65, height: 65,alignment: .center)
                    
                 
                })
                
                Button(action: {
                 
                 rightSwipe()
                }, label: {
                    
                    Image("right")
                })
                
            }
            .padding(.bottom, 50)
            
            
        }.onAppear(){
            firstedge = ((screen.width - (screen.width * 0.8)) / 2)
            viewmodel.selectedsonglist = songlist
          setPlayer()
        }
        .onDisappear(){
            
          timer.upstream.connect().cancel()
        }
    

        .gesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
               .onEnded { value in
                   if abs(value.translation.height) < abs(value.translation.width) {
                       if abs(value.translation.width) > 50.0 {
                           if value.translation.width < 0 {
                            // rightSwipe()
                           } else if value.translation.width > 0 {
                               presentationMode.wrappedValue.dismiss()
                             
                           }
                       }
                   }
               })
    }
    
    func setPlayer(){
        
//
          
   
        
        if viewmodel.selectedsong != song{
            viewmodel.selectedsong = song
            
            viewmodel.setPlayer(audiourl: song?.url ?? ""){
                downloadAmount = viewmodel.player.currentTime
                totalamount = viewmodel.player.duration
                let c = TimeInterval(downloadAmount)
                starttime = c.stringFromTimeInterval()
                endtime = viewmodel.player.duration.stringFromTimeInterval()
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            }
        }else{
            
            totalamount = viewmodel.player.duration
            endtime = viewmodel.player.duration.stringFromTimeInterval()
            downloadAmount = viewmodel.player.currentTime
            let c = TimeInterval(downloadAmount)
            starttime = c.stringFromTimeInterval()
            print(starttime)
            
        }
        
       
        
    }
    
    func leftSwipe(){
        if viewmodel.selectedindex != 0{
            timer.upstream.connect().cancel()
            downloadAmount = 0
            viewmodel.selectedindex = viewmodel.selectedindex - 1
            song = songlist[viewmodel.selectedindex]
            starttime.removeAll()
            endtime.removeAll()
         
            setPlayer()
        }
        
    }
    
    func rightSwipe(){
        print("index: \(viewmodel.selectedindex) \(downloadAmount)")
        
        if viewmodel.selectedindex < songlist.count - 1{
            timer.upstream.connect().cancel()
            downloadAmount = 0
            viewmodel.selectedindex = viewmodel.selectedindex + 1
            song = songlist[viewmodel.selectedindex]
            starttime.removeAll()
            endtime.removeAll()
         
            setPlayer()
        }
        
    }
}
