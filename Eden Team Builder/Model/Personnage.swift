//
//  Personnage.swift
//  Eden Team Builder
//
//  Created by Sébastien Gilabert on 15/03/2018.
//  Copyright © 2018 Sébastien Gilabert. All rights reserved.
//

import Foundation
import RealmSwift

enum Faction: String, EnumCollection
{
    case ISC
    case Convoi
    case Matriarcat
    case Horde
    case Khan
    case Immortels
    case Jokers
    case Resistance
    case Nephilim
    case Ange
    case Bamaka
    
    static func toString() -> [String]
    {
        var stringArray: [String] = []
        
        let iterator = Faction.cases().makeIterator()
        
        while let value = iterator.next()
        {
            stringArray.append(value.rawValue)
        }
        
        return stringArray
    }
    
    static func from(string: String) -> Faction?
    {
        var i: Int = 0
        for item in Faction.toString()
        {
            if item == string
            {
                let iterator = Faction.cases().makeIterator()
                var j =  0
                while let faction = iterator.next()
                {
                    if j == i
                    {
                        return faction
                    }
                    j = j + 1
                }
            }
            i = i + 1
        }
        
        return nil
    }
}

class Personnage : Object
{
    override static func primaryKey() -> String?
    {
        return "id"
    }
    
    @objc dynamic var id = UUID().uuidString
    
    @objc dynamic var nom : String = ""
    @objc dynamic var image: Data = Data()
    
    @objc dynamic var psy : Int = 4
    @objc dynamic var psyRed : Int = 3
    @objc dynamic var psyCP: Int = 3
    @objc dynamic var psyCPRed: Int = 5
    
    @objc dynamic var vig: Int = 5
    @objc dynamic var vigRed: Int = 3
    @objc dynamic var vigCP: Int = 2
    @objc dynamic var vigCPRed: Int = 5
    
    @objc dynamic var cbt: Int = 6
    @objc dynamic var cbtRed: Int = 2
    @objc dynamic var cbtCP: Int = 2
    @objc dynamic var cbtCPRed: Int = 4
    
    @objc dynamic var rap: Int = 4
    @objc dynamic var rapRed: Int = 3
    @objc dynamic var rapCP: Int = 2
    @objc dynamic var rapCPRed: Int = 4
    
    @objc private dynamic var factionString = Faction.Jokers.rawValue
    
    var faction: Faction
    {
        get
        {
            return Faction(rawValue: factionString)!
        }
        set
        {
            factionString = newValue.rawValue
        }
    }
}
