//
//  Modele+CoreDataProperties.swift
//  Renard_Drouot
//
//  Created by YGGTorrent on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//
//

import Foundation
import CoreData


extension Modele {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Modele> {
        return NSFetchRequest<Modele>(entityName: "Modele")
    }

    @NSManaged public var nom: String?
    @NSManaged public var modules: NSSet?

}

// MARK: Generated accessors for modules
extension Modele {

    @objc(addModulesObject:)
    @NSManaged public func addToModules(_ value: Module)

    @objc(removeModulesObject:)
    @NSManaged public func removeFromModules(_ value: Module)

    @objc(addModules:)
    @NSManaged public func addToModules(_ values: NSSet)

    @objc(removeModules:)
    @NSManaged public func removeFromModules(_ values: NSSet)

}
