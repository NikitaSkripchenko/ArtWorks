//
//  artwork.swift
//  FoodTracker
//
//  Created by Nikita Skripchenko on 05.05.2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class ArtWork {
    var name: String
    var description: String
    var genre: String
    var year: String
    var image: UIImage?
    
    init?(name: String, description: String, genre: String, year: String, image: UIImage?) {
        if name.isEmpty {
            return nil
        }
        self.name = name
        self.description = description
        self.genre = genre
        self.year = year
        self.image = image
    }
}
