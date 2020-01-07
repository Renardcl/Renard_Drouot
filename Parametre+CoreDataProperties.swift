//
//  Parametre+CoreDataProperties.swift
//  Renard_Drouot
//
//  Created by YGGTorrent on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//
//

import Foundation
import CoreData


extension Parametre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parametre> {
        return NSFetchRequest<Parametre>(entityName: "Parametre")
    }

    @NSManaged public var nom: String?
    @NSManaged public var objectif: String?
    @NSManaged public var theorique: String?
    @NSManaged public var module: Module?

}
