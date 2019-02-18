//
//  PokemonDeckViewController.swift
//  PokemonClone
//
//  Created by D@ on 2/4/19.
//  Copyright © 2019 Max Luu. All rights reserved.
//

import UIKit

class PokemonDeckViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pokeDeckTableView: UITableView!
    var caughtPokemon : [Pokemon] = []
    var unCaughtPokemon : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caughtPokemon = getPokemon(caught: true)
        unCaughtPokemon = getPokemon(caught: false)
        
        pokeDeckTableView.dataSource = self
        pokeDeckTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caught"
        } else {
            return "Uncaught"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return caughtPokemon.count
        } else {
            return unCaughtPokemon.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = caughtPokemon[indexPath.row]
        } else {
            pokemon = unCaughtPokemon[indexPath.row]
        }
        cell.textLabel?.text = pokemon.name
        if let pokemonImage = pokemon.image {
            cell.imageView?.image = UIImage(named: pokemonImage)
        }
        
        return cell
    }
    
    @IBAction func returnToMapViewTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
