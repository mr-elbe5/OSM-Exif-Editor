//
//  ExifEditView.swift
//  OSM Exif Editor
//
//  Created by Michael Rönnau on 17.01.25.
//

import SwiftUI

struct ExifEditView: View {
    
    @State var mainStatus = MainStatus.shared
    
    @State var name = ""
    
    var body: some View {
        VStack{
            HStack{
                Text("Exif Data")
                Spacer()
            }
            .padding()
            Form{
                TextField("Name", text: $name)
            }
            .padding()
            .onAppear(){
                if let item = mainStatus.currentImage{
                    debugPrint(item.fileName)
                }
            }
            Spacer()
        }
        
    }
    
}
