/*
 OSM Maps
 Display and use of OSM maps
 Copyright: Michael Rönnau mr@elbe5.de
 */

import AppKit

class ImagePresenterView: PresenterView {
    
    var items = ImageList()
    
    var imageView = NSImageView()
    
    override var itemCount: Int{
        items.count
    }
    
    override func setupItemView(){
        imageView.autoresizingMask = [.height, .width]
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubviewFilling(imageView)
        
    
    }
    
    func setImages(_ images: ImageList){
        self.items = images
        setImageView(image: images.first)
        currentIdx = 0
        checkButtons()
    }
    
    func setImage(image: ImageData){
        var arr = ImageList()
        arr.append(image)
        setImages(arr)
        checkButtons()
    }
    
    func setImageView(image: ImageData?){
        imageView.image = nil
        imageView.isHidden = true
        if let image = image, let img = image.image{
            imageView.isHidden = false
            imageView.image = img
        }
    }
    
    override func setCurrentItem(){
        setImageView(image: items[currentIdx])
    }
    
}




