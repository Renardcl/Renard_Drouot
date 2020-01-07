//
//  UtilisationModeleTableView.swift
//  Renard_Drouot
//
//  Created by YGGTorrent on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

                                                                                //YourCellDelegate
class UtilisationModeleTableView: UITableView, NSFetchedResultsControllerDelegate {


    @IBOutlet weak var titre: UINavigationItem!
    
    var modele = [Modele]()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantUtilisationModeleCellule = "CelluleUtilisationModeleAffichage"  //A atttribué
    
    let idModele:String = ""
    
    
    
    func viewDidLoad() {
        
        titre.title = "Modèles"
        
        print("Utilisation Modèles-------------------------------------------------")
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                
                //self.fetchResults()
                
            }
            
            
        }
        
    }
  
    
///tableView functions
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nombreLignes = fetchedResultsController.fetchedObjects?.count else {return 0}     //TODO
        return nombreLignes
    }
    
    //Remplissage cellule
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifiantUtilisationModeleCellule, for: indexPath)  as? CelluleTableViewCell else
        {
            print("DEBUG : /Module/Cellule/ cellule de mauvais type")
            //On return un truc de base
            return UITableViewCell()
        }
        
        /*let module = fetchedResultsController.object(at: indexPath)
        
        //intialisaiton cellule
        cell.cellDelegate = self
        
        //configuration cellule
        cell.configure(cell, at: indexPath, module:module)*/
        
        return cell
    }
    
    
    
    
    
    
    
    
///FetchedController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Module> = {
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Module> = Module.fetchRequest()
        
        // Paramétrage Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        
        //Ajout d'un predicate pour spécifier la request
        let predicate = NSPredicate(format: "modele.nom == %@", idModele)
        fetchRequest.predicate = predicate
        
        // Création Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Paramètrage Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            print("DEBUG : /UT-Modele/FetchController/ INSERT")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : /UT-Modele/FetchController/ UPDATE")
                let module = fetchedResultsController.object(at: indexPath)
                cell.textLabel?.text = module.nom
            }
            
        default :
            print("DEBUG : /UT-Modele/FetchController/ DEFAULT")
        }
        
    }
    
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("DEBUG: /Module/FetchController/beginUpdates")
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("DEBUG: /Module/FetchController/endUpdates")
        tableView.endUpdates()
    }
    
    
}

