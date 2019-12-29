//
//  ModelesTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 17/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

class ModelesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, YourCellDelegate {
    
    func didPressButton(cell:CelluleTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        //print("DEBUG : /Modele / didPressButton / index path  :", indexPath?.row)
        let modele = fetchedResultsController.object(at: indexPath!)
        //print("DEBUG : /Modele / didPressButton / modele : ", modele.nom)
        modele.managedObjectContext?.delete(modele)
    }
    


    @IBOutlet weak var AddButton: UIBarButtonItem!

    
    @IBOutlet weak var titre: UINavigationItem!
    
    var modele = [Modele]()
    
   private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantModeleCellule = "CelluleModeleAffichage"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titre.title = "Modèles"
        
        print("Modèles-------------------------------------------------")


        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                //self.delData()
                
                self.fetchResults()
                
            }
            //print("Debug : /Modele/viewDidLoad/fin")
            

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
        //print("DEBUG: /fetchResult/fetch performed")
        
    }
    
 ///Creation object Modele
    func newModele(){
        fetchResults()
        
        if let modeles = fetchedResultsController.fetchedObjects{
            //print("DEBUG: /Modele/newModele/modeles fetched OK ")
            
            //Initialisation des Parametres
            var newModele = NSEntityDescription.insertNewObject(forEntityName: "Modele", into:persistentContainer.viewContext)
            newModele.setValue("newModele", forKey: "nom")
            
            
            //Sauvegarde
            do {
                try persistentContainer.viewContext.save()
                print("PersistentContainer saved")
            } catch {
                print("Unable to Save Changes")
                print("\(error), \(error.localizedDescription)")
            }
            
            //Chargement des nouvelles valeurs
            fetchResults()
        }
        else {
            print("DEBUG: /newModele/fetchedObjects Failed")
        }
        //print("DEBUG: /Modele/NewModele/fin new Modele")

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifiantModeleCellule, for: indexPath)  as? CelluleTableViewCell else
        {
            print("DEBUG : /Modele/Cellule/ cellule de mauvais type")
            //On return un truc de base
            return UITableViewCell()
        }
        
        
        let modele = fetchedResultsController.object(at: indexPath)
        
        cell.cellDelegate = self
        
        cell.configure(cell, at: indexPath, modele:modele)
        
        
        return cell
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
        fetchedResultsController.delegate = self   
        
        return fetchedResultsController
    }()
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            print("DEBUG : /Modele/FetchController/ INSERT")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : /Modele/FetchController/ UPDATE")
                let modele = fetchedResultsController.object(at: indexPath)
                cell.textLabel?.text = modele.nom
            }
        case .delete :
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            print("DEBUG : /Modele/FetchController/ DELETE")
        default :
            print("DEBUG : /Modele/FetchController/ DEFAULT")
        }
        
    }
    
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("DEBUG: /Modele/FetchController/WillChangeContent/beginUpdates")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // print("DEBUG: /Modele/FetchController/DidChangeContent/endUpdates")
        tableView.endUpdates()
        
    }
 
    
///Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddModele" {
            //On crée un nouveau modele
            newModele()
            
            //print("DEBUG: /Modele/ segueAction/ avant passage parametre newModele")
            
            if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
                destinationVC.idModele = "newModele"

            }
            else{
                print("DEBUG: /Modele/ segueAction/ definition du segue destination failed")
            }
        }
        
        if segue.identifier == "ModifyModele" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return }
            let modele = fetchedResultsController.object(at: indexPath)
            
            if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
                //print("DEBUG : /modele / segueAction / modele.nom : ", modele.nom)
                destinationVC.idModele = modele.nom!
            }
        }
        
    }
    

///Autres
    //Suppression données
    func delData(){
        let fetchReqModele:NSFetchRequest<Modele> = Modele.fetchRequest()
        if let result = try? persistentContainer.viewContext.fetch(fetchReqModele){
            for obj in result {
                persistentContainer.viewContext.delete(obj)
            }
        }
        
        let fetchReqModule:NSFetchRequest<Module> = Module.fetchRequest()
        if let result = try? persistentContainer.viewContext.fetch(fetchReqModule){
            for obj in result {
                persistentContainer.viewContext.delete(obj)
            }
        }
        
        let fetchReqParametre:NSFetchRequest<Parametre> = Parametre.fetchRequest()
        if let result = try? persistentContainer.viewContext.fetch(fetchReqParametre){
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

    
   override func viewWillAppear(_ animated: Bool)
   {
        fetchResults()

    }
    override func viewWillDisappear(_ animated: Bool) {
        //print("DEBUG op : Wiew will diseappear")
        fetchResults()
        do {
            try persistentContainer.viewContext.save()
            print("PersistentContainer saved")
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }


}



