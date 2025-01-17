//
//  ExifEditView.swift
//  OSM Exif Editor
//
//  Created by Michael Rönnau on 17.01.25.
//

import SwiftUI

struct ExifEditView: View {
    
    @State var mainStatus = MainStatus.shared
    
    var body: some View {
        VStack{
            HStack{
                Text("Exif Data")
                Spacer()
            }
            if let item = mainStatus.currentImage, let image = item.getImage() {
                Form{
                    
                }
            }
            Spacer()
        }
        
    }
    
}
