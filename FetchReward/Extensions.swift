//
//  Extensions.swift
//  FetchReward
//
//  Created by JOEL CRAWFORD on 11/23/21.
//

//

//


import UIKit

//var imageCache = NSCache()

let imageCache = NSCache<NSString, UIImage>()





extension UIFont {
    var bold: UIFont {
        return with(.traitBold)
    }
    
    var italic: UIFont {
        return with(.traitItalic)
    }
    
    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }
    
    
    
    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}



extension UIImageView {
    var isEmpty: Bool { image == nil }
    
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    
    
    
    
    
    func loadImageUsingCacheFromUrlString(urlString: String) {
        
        //Avoid reusing the image, incase in a collection View or table view that resuses a cell
        // self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            
            return
        }
        
        //Otherwise fireoff a new download
        
        let url = NSURL(string: urlString)
        
        URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            
            if(error != nil){
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.main.async{
                if let downloadedImage = UIImage(data: data!) {
                    //Image chache expects a non optional image
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    
                    self.image = downloadedImage
                    
                }
                
                
            }
            
        }.resume()
        
        
    }
}























