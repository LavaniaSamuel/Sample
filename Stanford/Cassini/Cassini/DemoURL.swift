//
//  DemoURL.swift
//  Cassini
//
//  Created by Samuel Lavania on 4/6/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import Foundation

struct DemoURL {
    static let stanford = URL(string: "http://stanford.edu/about/images/intro_about.jpg")
    
    static var NASA: Dictionary<String,URL> =  {
        let NASAURLStrings = [
            "Cassini" : "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
            "Earth" : "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
            "Saturn" : "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"
        ]
        var urls = Dictionary<String, URL>()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
