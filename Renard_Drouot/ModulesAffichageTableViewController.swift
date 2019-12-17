//
//  ModulesAffichageTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 17/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

class ModulesAffichageTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var titre: UINavigationItem!
    @IBOutlet weak var AddButton: UIBarButtonItem!

    
    
    
    var module = [Module]()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantModuleCellule = "CelluleModuleAffichage"
    
    var idModele:String = ""   //nom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG : /Module/viewLoad/Push Validé !")
        
        titre.title="Modules"
        
        print("DEBUG: /module/ViewLoad/idModele", idModele)
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                //TODO
                
            }
            print("Debug : /viewDidLoad/fin")
            
            //self.delData()
        }
        
    }
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modules = fetchedResultsController.fetchedObjects else { return 0 }
        print("Debug : /Modules/tableView/modules.count  : ", modules.count)
        return modules.count
    }
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantModuleCellule, for: indexPath)
        
        //configureCell
        //Todo : configureCell(cell, at: indexPath)
        
        
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath : IndexPath){
        let module = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = module.nom
    }
    
    
    
    
    ///FetchedController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Module> = {
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Module> = Module.fetchRequest()
        
        // Paramétrage Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        
        // Création Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Paramètrage Fetched Results Controller
        fetchedResultsController.delegate = self   //bizarre
        
        return fetchedResultsController
    }()
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            print("DEBUG : /Module/FetchController/ switch insert")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : /Module/FetchController/ switch update")
                //TODO : configureCell(cell,at : indexPath)
            }
        default :
            print("DEBUG : /Module/FetchController/ switch default")
        }
        
    }
    
    
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: /Module/FetchController/beginUpdates")
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: /Module/FetchController/endUpdates")
        tableView.endUpdates()
        
    }
    
    
///Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddModule" {
            //TODO : newModule()
            
            print("DEBUG: /Module/ segueAction/ avant passage parametre newModule")
            //TODO
            /*if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
                destinationVC.idModele = "newModule"
            }
            else{
                print("DEBUG: /Module/ segueAction/ definition du segue destination failed")
            }*/
        }
        if segue.identifier == "ModifyModule" {
            /*
            //TODO :
            if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
                //TODO : passer un identifiant du modele : destinationVC.idModele = "newModele"
            }*/
        }
        
    }
    
    
///Autres
    //Suppression données
    func delData(){
        let fetchReq:NSFetchRequest<Module> = Module.fetchRequest()
        if let result = try? persistentContainer.viewContext.fetch(fetchReq){
            for obj in result {
                persistentContainer.viewContext.delete(obj)
            }
        }
        
        //Sauvegarde
        do {
            try persistentContainer.viewContext.save()
            print("PersistentContainer saved")
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }


}
