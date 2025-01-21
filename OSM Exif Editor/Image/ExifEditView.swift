//
//  ExifEditView.swift
//  OSM Exif Editor
//
//  Created by Michael Rönnau on 17.01.25.
//

import SwiftUI

struct ExifEditView: View {
    
    @State var currentImage = CurrentImage.shared
    @State private var showSaveResult: Bool = false
    @State private var resultText: String = ""
    
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
                if let width = currentImage.imageData?.width, let height = currentImage.imageData?.height{
                    Text("\(width) x \(height)")
                }
                Spacer()
            }
            .padding(5)
            HStack{
                Text("brightness/aperture".localize())
                if let brightness = currentImage.imageData?.brightness, let aperture = currentImage.imageData?.aperture{
                    Text("\(brightness) / \(aperture)")
                }
                Spacer()
            }
            .padding(5)
            HStack{
                Text("cameraModel".localize())
                if let cameraModel = currentImage.imageData?.cameraModel{
                    Text(String(cameraModel))
                }
            }
            .padding(5)
            DatePicker("creationDate".localize(), selection: $currentImage.dateTime, displayedComponents: [.date, .hourAndMinute])
                .padding(5)
            HStack{
                Text("latitude".localize())
                TextField("", value: $currentImage.latitude, format: .number)
                    .onChange(of: currentImage.latitude, initial: false) { _,_ in
                        if let coordinate = currentImage.coordinate{
                            MapStatus.shared.centerCoordinate = coordinate
                            MapTiles.shared.update()
                        }
                    }
            }
            .padding(5)
            HStack{
                Text("longitude".localize())
                TextField("", value: $currentImage.longitude, format: .number)
                    .onChange(of: currentImage.longitude, initial: false) { _,_ in
                        if let coordinate = currentImage.coordinate{
                            MapStatus.shared.centerCoordinate = coordinate
                            MapTiles.shared.update()
                        }
                    }
            }
            .padding(5)
            HStack{
                Text("altitude".localize())
                TextField("", value: $currentImage.altitude, format: .number)
            }
            .padding(5)
            Button("saveToImage".localize(), action: {
                if currentImage.updateImageData(){
                    resultText = "imageSaved".localize()
                }
                else{
                    resultText = "imageNotSaved".localize()
                }
                showSaveResult = true
            })
            .padding(5)
            .alert(resultText, isPresented: $showSaveResult, actions: {
            })
            Spacer()
        }
        .padding()
    }
    
}

#Preview {
    ExifEditView()
}
