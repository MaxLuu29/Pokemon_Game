//
//  MapViewController.swift
//  PokemonClone
//
//  Created by D@ on 2/4/19.
//  Copyright © 2019 Max Luu. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapDisplayView: MKMapView!
    var locationManager = CLLocationManager()
    var updateCount = 0
    var pokemonsArr : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonsArr = getAllPokemon()
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            initSetUp()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            initSetUp()
        }
    }
    
    func initSetUp() {
        mapDisplayView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        mapDisplayView.delegate = self
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.locationManager.location?.coordinate {
                var pokeCoord = center
                pokeCoord.latitude += (Double.random(in: 0...200) - 100.0) / 50000.0
                pokeCoord.longitude += (Double.random(in: 0...200) - 100.0) / 50000.0
                
                if let pokemon = self.pokemonsArr.randomElement() {
                    let obj = PokemonObj(coordinate: pokeCoord, pokemon: pokemon)
                    self.mapDisplayView.addAnnotation(obj)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "Ash_72px")
        } else {
            if let pokeObj = annotation as? PokemonObj {
                if let imageName = pokeObj.pokemon.image {
                    annotationView.image = UIImage(named: imageName)
                }
            }
        }
        
        var frame = annotationView.frame
        frame.size.height = 50.0
        frame.size.width = 50.0
        annotationView.frame = frame
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapDisplayView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            
        } else {
            if let centerCoord = locationManager.location?.coordinate {
                
                if let pokeCoord = view.annotation?.coordinate {
                    
                    let region = MKCoordinateRegion(center: pokeCoord, latitudinalMeters: 200, longitudinalMeters: 200)
                    mapDisplayView.setRegion(region, animated: false)
                    
                    if let pokeAnnotation = view.annotation as? PokemonObj {
                        
                        if let pokemonName = pokeAnnotation.pokemon.name {
                            
                            if mapDisplayView.visibleMapRect.contains(MKMapPoint(centerCoord)) {
                                
                                print("pokemon caught")
                                pokeAnnotation.pokemon.isCaught = true
                                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                                
                                let alert = UIAlertController(title: "Congrats", message: "You caught a \(pokemonName)", preferredStyle: .alert)
                                let pokeDeckAction = UIAlertAction(title: "PokeDeck", style: .default) { (action) in
                                    self.performSegue(withIdentifier: "pokeDeckSegue", sender: nil)
                                }
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alert.addAction(pokeDeckAction)
                                alert.addAction(okAction)
                                present(alert, animated: true, completion: nil)
                                
                            } else {
                                print("pokemon out of range")
                                let alertOutOfRange = UIAlertController(title: "Pokemon out of range", message: "You were too far from this \(pokemonName) to catch it, try moving closer", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertOutOfRange.addAction(okAction)
                                present(alertOutOfRange, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            if let centerUserLocation = locationManager.location?.coordinate {
                let region = MKCoordinateRegion(center: centerUserLocation, latitudinalMeters: 200, longitudinalMeters: 200)
                mapDisplayView.setRegion(region, animated: false)
            }
            updateCount += 1
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func compassTapped(_ sender: Any) {
        if let centerUserLocation = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: centerUserLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapDisplayView.setRegion(region, animated: true)
        }
    }
    
}
