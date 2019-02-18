//
//  CoreData.swift
//  PokemonClone
//
//  Created by D@ on 2/4/19.
//  Copyright © 2019 Max Luu. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
    createPokemon(name: "Pikachu", imageName: "Pikachu", caught: false)
    createPokemon(name: "Zubat", imageName: "Zubat", caught: false)
    createPokemon(name: "Charmander", imageName: "Charmander", caught: false)
    createPokemon(name: "Mewtwo", imageName: "Mewtwo", caught: false)
    createPokemon(name: "Snorlax", imageName: "Snorlax", caught: false)
}

func createPokemon(name: String, imageName: String, caught: Bool) {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        let pokemon = Pokemon(context: context)
        pokemon.image = imageName
        pokemon.name = name
        pokemon.isCaught = caught
        try? context.save()
    }
}

func getAllPokemon() -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        if let pokemonData = try? context.fetch(Pokemon.fetchRequest()) as? [Pokemon] {
            if let pokemons = pokemonData {
                if pokemons.count == 0 {
                    addAllPokemon()
                    return getAllPokemon()
                } else {
                    return pokemons
                }
            }
        }
    }
    return []
}

func getPokemon(caught: Bool) -> [Pokemon] {
    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        
        let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        if caught {
            fetchRequest.predicate = NSPredicate(format: "isCaught == true")
        } else {
            fetchRequest.predicate = NSPredicate(format: "isCaught == false")
        }
        if let pokemons = try? context.fetch(fetchRequest) {
            return pokemons
        } else {
            print("FETCH ERRORRRR")
            return []
        }
    }
    return []
}
