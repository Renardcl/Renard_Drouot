//
//  ParametresAffichageTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 17/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

//Creation nouveau
    //segue to listParametre
    //creation d'un parametre a afficher

//Modif existant :
    //Recuperation/envoi du module dans CoreData

//NAV
    //ajouter cancel

class ParametresAffichageTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{


    @IBOutlet weak var AddButton: UIBarButtonItem!
    @IBAction func ActionAddButton(_ sender: Any) {
        //TODO : Creation d'un nouveau module dans lequel le parametre selctionner sera ajouter
        
    }
    @IBOutlet weak var titreTextField: UITextField!
    

    
    var parametre = [Parametre]()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantParametreCellule = "CelluleParametreAffichage"
    
    var idModele:String = ""
    var idModule:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titreTextField.text = idModule
        
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
            print("Debug : /viewDidLoad/fin")
        }
        
    }
    
//FetchResult
    func fetchResults(){
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        print("DEBUG: /Parametre/fetchResults/fetch performed")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantParametreCellule, for: indexPath)
        
        //configureCell
        //Todo : configureCell(cell, at: indexPath)

        
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath : IndexPath){
        let parametre = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = parametre.nom
    }
    

    
    
///FetchedController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Parametre> = {
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Parametre> = Parametre.fetchRequest()
        
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
            print("DEBUG : /Parametre/FetchController/ switch insert")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : /Parametre/FetchController/ switch update")
                //TODO : configureCell(cell,at : indexPath)
            }
        default :
            print("DEBUG : /Parametre/FetchController/ switch default")
        }
        
    }
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: /Parametre/FetchController/beginUpdates")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: /Parametre/FetchController/endUpdates")
        tableView.endUpdates()
        
    }
    
///Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddParametre" {
            if let destinationVC = segue.destination as? ListeParametresTableViewController {
                print("DEBUG: Parametre/segueAddParametre/idModele", idModele)
                destinationVC.idModele = idModele
            }
        }
        if segue.identifier == "Cancel" {
             if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
             destinationVC.idModele = idModele
             }
        }
        if segue.identifier == "ModifyParametre" {
            /*if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
             destinationVC.idModele =
             }*/
        }
        
    }
    
///Autres
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
    //Suppression données
    func delData(){
        let fetchReq:NSFetchRequest<Parametre> = Parametre.fetchRequest()
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




