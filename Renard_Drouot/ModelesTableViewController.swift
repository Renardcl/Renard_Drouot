//
//  ModelesTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 17/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

class ModelesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var AddButton: UIBarButtonItem!

    
    @IBOutlet weak var titre: UINavigationItem!
    
    var modele = [Modele]()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantModeleCellule = "CelluleModeleAffichage"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titre.title = "Modèles"
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                self.fetchResults()
                
            }
            print("Debug : /Modele/viewDidLoad/fin")
            
            //self.delData()
        }
        
    }


    
    
///FetchResult
    func fetchResults(){
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        print("DEBUG: fetchResult/fetch performed")
        
    }
    
 ///Creation object
    func newModele(){
        fetchResults()
        
        if let modeles = fetchedResultsController.fetchedObjects{
            print("DEBUG: /newModele/modeles ? ")
            
            //Initialisation des Parametres
            var newModele = NSEntityDescription.insertNewObject(forEntityName: "Modele", into:persistentContainer.viewContext)
            newModele.setValue("newModele", forKey: "nom")
            
            
            /*//Sauvegarde
            do {
                try persistentContainer.viewContext.save()
                print("PersistentContainer saved")
            } catch {
                print("Unable to Save Changes")
                print("\(error), \(error.localizedDescription)")
            }*/
            
            //Chargement des nouvelles valeurs
            fetchResults()
        }
        else {
            print("DEBUG: /newModele/fetchedObjects Failed")
        }
        print("DEBUG: /Modele/NewModele/fin new Modele")
    }
    
///tableView functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let modeles = fetchedResultsController.fetchedObjects else { return 0 }
        //print("Debug : /Modeles/tableView/modeles.count  : ", modeles.count)
        return modeles.count

    }
    
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantModeleCellule, for: indexPath)
        
        
        //configureCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath : IndexPath){
        let modele = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = modele.nom
    }
    
    
    
///FetchedController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Modele> = {
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Modele> = Modele.fetchRequest()
        
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
            print("DEBUG : /Modele/FetchController/ switch insert")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : /Modele/FetchController/ switch update")
                //TODO : configureCell(cell,at : indexPath)
            }
        default :
            print("DEBUG : /Modele/FetchController/ switch default")
        }
        
    }
    
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: /Modele/FetchController/WillChangeContent/beginUpdates")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: /Modele/FetchController/DidChangeContent/endUpdates")
        tableView.endUpdates()
        
    }
 
    
///Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddModele" {
            newModele()
            
            print("DEBUG: /Modele/ segueAction/ avant passage parametre newModele")
            if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
                destinationVC.idModele = "newModele"
            }
            else{
                print("DEBUG: /Modele/ segueAction/ definition du segue destination failed")
            }
        }
        if segue.identifier == "ModifyModele" {
            newModele()
            
            if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
                //TODO : passer un identifiant du modele : destinationVC.idModele = "newModele"
            }
        }
        
    }
    
    
///Autres
    //Suppression données
    func delData(){
        let fetchReq:NSFetchRequest<Modele> = Modele.fetchRequest()
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


