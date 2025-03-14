//
//  ExifEditView.swift
//  OSM Exif Editor
//
//  Created by Michael Rönnau on 17.01.25.
//

import SwiftUI

struct ExifEditView: View {
    
    @State var currentImage = CurrentImage.shared
    @State var setCreationDate: Bool = false
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
            .padding(3)
            HStack{
                Text("selectedImage".localizeWithColon())
                Text(currentImage.imageData?.url.lastPathComponent ?? "noImageSelected".localize())
            }
            .padding(2)
            HStack{
                Text("size".localizeWithColon())
                if let width = currentImage.imageData?.width, let height = currentImage.imageData?.height{
                    Text("\(Int(width)) x \(Int(height))")
                }
                Spacer()
            }
            .padding(2)
            HStack{
                Text("brightness/aperture".localizeWithColon())
                if let brightness = currentImage.imageData?.brightness, let aperture = currentImage.imageData?.aperture{
                    Text("\(brightness) / \(aperture)")
                }
                Spacer()
            }
            .padding(2)
            HStack{
                Text("cameraModel".localizeWithColon())
                if let cameraModel = currentImage.imageData?.cameraModel{
                    Text(String(cameraModel))
                }
            }
            .padding(2)
            HStack{
                DatePicker("creationDate".localizeWithColon(), selection: $currentImage.dateTime, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.stepperField)
                    .padding(5)
                Button(action: {
                    ExifClipboard.shared.copyDate()
                }) {
                    Image(systemName: "document.on.document")
                }
                .help("copy".localize())
                Button(action: {
                    ExifClipboard.shared.pasteDate()
                }) {
                    Image(systemName: "document.on.clipboard")
                }
                .help("paste".localize())
            }
            Button("setNow".localize(), action: {
                currentImage.dateTime = Date.now
            })
            .padding(2)
            Toggle(isOn: $setCreationDate) {
                Text("setCreationDate".localize())
                        }
                        .toggleStyle(.checkbox)
            HStack{
                VStack{
                    HStack{
                        Text("latitude".localizeWithColon())
                        TextField("", value: $currentImage.latitude, format: .number)
                            .onChange(of: currentImage.latitude, initial: false) { _,_ in
                                if let coordinate = currentImage.coordinate{
                                    MapStatus.shared.centerCoordinate = coordinate
                                }
                            }
                    }
                    HStack{
                        Text("longitude".localizeWithColon())
                        TextField("", value: $currentImage.longitude, format: .number)
                        
                            .onChange(of: currentImage.longitude, initial: false) { _,_ in
                                if let coordinate = currentImage.coordinate{
                                    MapStatus.shared.centerCoordinate = coordinate
                                }
                            }
                    }
                    HStack{
                        Text("altitude".localizeWithColon())
                        TextField("", value: $currentImage.altitude, format: .number)
                    }
                }
                Button(action: {
                    ExifClipboard.shared.copyLocation()
                }) {
                    Image(systemName: "document.on.document")
                }
                .help("copy".localize())
                Button(action: {
                    ExifClipboard.shared.pasteLocation()
                }) {
                    Image(systemName: "document.on.clipboard")
                }
                .help("paste".localize())
            }.padding(2)
            Button("copyMapLocation".localize(), action: {
                currentImage.latitude = MapStatus.shared.centerCoordinate.latitude
                currentImage.longitude = MapStatus.shared.centerCoordinate.longitude
            })
            .padding(2)
            .alert(resultText, isPresented: $showSaveResult, actions: {
            })
            Button("getAltitude".localize(), action: {
                ElevationProvider.shared.getElevation(at: MapStatus.shared.centerCoordinate) { elevation in
                    currentImage.altitude = elevation
                }
            })
            .padding(2)
            .alert(resultText, isPresented: $showSaveResult, actions: {
            })
            Button("saveToImage".localize(), action: {
                if currentImage.updateImageData(updateCreation: setCreationDate){
                    resultText = "imageSaved".localize()
                }
                else{
                    resultText = "imageNotSaved".localize()
                }
                showSaveResult = true
            })
            .padding(2)
            .disabled(currentImage.imageData == nil)
            .alert(resultText, isPresented: $showSaveResult, actions: {
            })
        }
        .padding()
    }
    
}

#Preview {
    ExifEditView()
}
