//
//  ModeleObject.swift
//  Renard_Drouot
//
//  Created by YGGTorrent on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

class ModeleObject: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Modele> {
        return NSFetchRequest<Modele>(entityName: "Modele")
    }
    
    @NSManaged public var nom: String?
    @NSManaged public var modules: NSSet?
    
    
    @objc(addModulesObject:)
    @NSManaged public func addToModules(_ value: Module)
    
    @objc(removeModulesObject:)
    @NSManaged public func removeFromModules(_ value: Module)
    
    @objc(addModules:)
    @NSManaged public func addToModules(_ values: NSSet)
    
    @objc(removeModules:)
    @NSManaged public func removeFromModules(_ values: NSSet)
    
    public func getModules() -> [Module]
    {
        var changement:Bool = true
        var tmp:Module
        var modules:[Module] = self.modules?.allObjects as! [Module]
        
        while changement {
            changement=false
            for i in (1...modules.count-1).reversed() {
                print (i)
                for j in 0...i-1 {
                    if modules[i].nom! < modules[j].nom!
                    {
                        tmp=modules[i]
                        modules[i]=modules[j]
                        modules[j]=tmp
                        changement = true
                    }
                    
                }
            }
        }
        
        
        return modules
    }
}
