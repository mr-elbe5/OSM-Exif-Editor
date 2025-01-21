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
                    .font(.system(size: 24))
                Spacer()
            }
            .padding(5)
            HStack{
                Text("size".localize())
                if let width = mainStatus.currentImage?.width, let height = mainStatus.currentImage?.height{
                    Text("\(width) x \(height)")
                }
                Spacer()
            }
            .padding(5)
            HStack{
                Text("brightness/aperture".localize())
                if let brightness = mainStatus.currentImage?.brightness, let aperture = mainStatus.currentImage?.aperture{
                    Text("\(brightness) / \(aperture)")
                }
                Spacer()
            }
            .padding(5)
            HStack{
                Text("cameraModel".localize())
                if let cameraModel = mainStatus.currentImage?.cameraModel{
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
