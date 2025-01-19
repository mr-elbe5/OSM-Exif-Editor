//
//  ExifEditView.swift
//  OSM Exif Editor
//
//  Created by Michael Rönnau on 17.01.25.
//

import SwiftUI

struct ExifEditView: View {
    
    @State var mainStatus = MainStatus.shared
    
    let insets = EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("exifData".localize())
                    .font(.headline)
                Spacer()
            }
            .padding(5)
            HStack{
                Text("width".localize())
                if let width = mainStatus.currentImage?.metaData.width{
                    Text(String(width))
                }
                Spacer()
            }
            .padding(5)
            HStack{
                Text("height".localize())
                if let height = mainStatus.currentImage?.metaData.height{
                    Text(String(height))
                }
                Spacer()
            }
            .padding(5)
            HStack{
                Text("cameraModel".localize())
                if let cameraModel = mainStatus.currentImage?.metaData.cameraModel{
                    Text(String(cameraModel))
                }
            }
            .padding(5)
            DatePicker("creationDate".localize(), selection: $mainStatus.dateTime, displayedComponents: [.date, .hourAndMinute])
                .padding(5)
            HStack{
                Text("latitude".localize())
                TextField("", value: $mainStatus.latitude, format: .number)
            }
            .padding(5)
            HStack{
                Text("longitude".localize())
                TextField("", value: $mainStatus.longitude, format: .number)
            }
            .padding(5)
            HStack{
                Text("altitude".localize())
                TextField("", value: $mainStatus.altitude, format: .number)
            }
            .padding(5)
            Button("saveToImage".localize(), action: {
                
            })
            .padding(5)
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    ExifEditView()
}
