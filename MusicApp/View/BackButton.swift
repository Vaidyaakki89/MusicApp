//
//  BackButton.swift
//  MusicApp
//
//  Created by AKSHAY VAIDYA on 08/04/24.
//

import Foundation
import SwiftUI

struct BackButton: View{
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
       
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 0) {
                    Image(uiImage: UIImage(named: "backbutton")!)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                       // .resizable().frame(width: 28, height: 25)
                      .padding(.trailing, 60)
                        .padding(.vertical, 10)
             // .border(.red)
                    Text("")
                }
            }
          
            
        
        
    }
}
