//
//  PokemonObj.swift
//  PokemonClone
//
//  Created by D@ on 2/5/19.
//  Copyright © 2019 Max Luu. All rights reserved.
//

import UIKit
import MapKit

class PokemonObj: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
}
