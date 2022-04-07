//
//  RecipeModel.swift
//  Recipe List App
//
//  Created by Christopher Ching on 2021-01-14.
//

import Foundation

class RecipeModel: ObservableObject {
    
    @Published var recipes = [Recipe]()
    
    init() {
        
        // Create an instance of data service and get the data
        self.recipes = DataService.getLocalData()
        
        
    }
    
    static func getPortion(ingredient: Ingredient, recipeServings: Int, targetServings: Int) -> String {
        var portion = ""
        var numerator = ingredient.num ?? 1
        var denominator = ingredient.denom ?? 1
        var wholePortions = 0
        
        if ingredient.num != nil {
            //Get a single serving size by multiplying denominator by the recipie servings
            denominator *= recipeServings
            
            //Get target portion by multiplying numerator by target servings
            numerator *= targetServings
            
            //Reduce fraction by GCD
            let divisor = Rational.greatestCommonDivisor(numerator, denominator)
            numerator /= divisor
            denominator /= divisor
            
            //Get the whole portions if num is greater than denom
            if numerator >= denominator {
                //Calculated whole portions
                wholePortions = numerator / denominator
                
                //Calculate reaminder
                numerator = numerator % denominator
                
                portion += String(wholePortions)
            }
            
            //Express remainder as fraction
            if numerator > 0 {
                
                //assign remainder
                portion += wholePortions > 0 ? " " : ""
                portion += "\(numerator)/\(denominator)"
                
            }
        }
        if var unit = ingredient.unit {
            
            //If we need to pluralize
            if wholePortions > 1 {
                //claculate appropriate suffix
                if unit.suffix(2) == "ch" {
                    unit += "es"
                } else if unit.suffix(1) == "f" {
                    unit = String(unit.dropLast())
                    unit += "ves"
                } else {
                    unit += "s"
                }
                
            }
            
            
            portion += ingredient.num == nil && ingredient.denom == nil ? "" : " "
            
            return portion + unit
        }
        
        return portion
    }
}
