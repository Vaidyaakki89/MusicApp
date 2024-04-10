//
//  SongViewModel.swift
//  MusicApp
//
//  Created by AKSHAY VAIDYA on 05/04/24.
//

import Foundation
import AVFoundation

class SongViewModel:ObservableObject{
    
    @Published var songlist = [SongData]()
    
    @Published var toptractlist = [SongData]()
    @Published  var player = AVAudioPlayer()
    @Published  var buttonname = "play"
    @Published var selectedsong:SongData?
    @Published var selectedindex = 0
    @Published var selectedsonglist = [SongData]()
    @Published var istimerOn = false
    
    func getSonglistapi(){
        
        guard let url = URL(string: "\(Network.base_url)/items/songs")
        else{
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {data, _, _ in
            
            guard let jsondata = data, let model = try? JSONDecoder().decode(SongsModel.self, from: jsondata)
                    
            else{
                
                return
            }
           
            DispatchQueue.main.async{
                
                self.songlist = model.data
                self.toptractlist = model.data.filter({$0.topTrack == true})
            }
        
            
        }).resume()
        
        
    }
    
    func setPlayer(audiourl:String, comp:(()->())? = nil){

        player.stop()
        let url = audiourl.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "https-", with: "https://").replacingOccurrences(of: "-r2-dev-", with: ".r2.dev/").replacingOccurrences(of: "-mp3", with: ".mp3")
        
        let songurl = URL(string:url)
        self.buttonname = "play"
        URLSession.shared.dataTask(with:songurl!){data,_,_ in
            DispatchQueue.main.async{
                self.player = try! AVAudioPlayer(data: data!)
                self.player.play()
                print(self.player.duration.stringFromTimeInterval())
                 comp?()
            }
            
        }.resume()
    }
    
    func controlPlayer(){
        
        if player.isPlaying{
            
            player.stop()
            buttonname = "pause"
           
        }
        else{
            
            player.play()
            buttonname = "play"
         
        }
        
    }
    
    
    
}



extension TimeInterval{

        func stringFromTimeInterval() -> String {

            let time = NSInteger(self)

            let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
            let seconds = time % 60
            let minutes = (time / 60) % 60
            let hours = (time / 3600)

            return String(format: "%0.2d:%0.2d",minutes,seconds)

        }
    }
