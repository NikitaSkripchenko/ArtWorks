//
//  artwork.swift
//  FoodTracker
//
//  Created by Nikita Skripchenko on 05.05.2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class ArtWork: NSObject, NSCoding {
    
    //MARK: Props
    var name: String
    var descriptionT: String
    var genre: String
    var year: String
    var image: UIImage?
    
    //MARK:
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("artworks")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let descriptionT = "descriptionT"
        static let genre = "genre"
        static let year = "year"
        static let image = "image"
    }
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(descriptionT, forKey: PropertyKey.descriptionT)
        aCoder.encode(genre, forKey: PropertyKey.genre)
        aCoder.encode(year, forKey: PropertyKey.year)
        aCoder.encode(image, forKey: PropertyKey.image)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for an object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        let descriptionT = aDecoder.decodeObject(forKey: PropertyKey.descriptionT) as? String
        let genre = aDecoder.decodeObject(forKey: PropertyKey.genre) as? String
        let year = aDecoder.decodeObject(forKey: PropertyKey.year) as? String
        
        // Must call designated initializer.
        self.init(name: name, descriptionT: descriptionT!, genre: genre!, year: year!, image: image)
        
    }
    
    
    init?(name: String, descriptionT: String, genre: String, year: String, image: UIImage?) {
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.descriptionT = descriptionT
        self.genre = genre
        self.year = year
        self.image = image
    }
}
