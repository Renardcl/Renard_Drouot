//
//  Module+CoreDataProperties.swift
//  Renard_Drouot
//
//  Created by YGGTorrent on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//
//

import Foundation
import CoreData


extension Module {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Module> {
        return NSFetchRequest<Module>(entityName: "Module")
    }

    @NSManaged public var nom: String?
    @NSManaged public var modele: Modele?
    @NSManaged public var parametres: NSSet?

}

// MARK: Generated accessors for parametres
extension Module {

    @objc(addParametresObject:)
    @NSManaged public func addToParametres(_ value: Parametre)

    @objc(removeParametresObject:)
    @NSManaged public func removeFromParametres(_ value: Parametre)

    @objc(addParametres:)
    @NSManaged public func addToParametres(_ values: NSSet)

    @objc(removeParametres:)
    @NSManaged public func removeFromParametres(_ values: NSSet)

}
