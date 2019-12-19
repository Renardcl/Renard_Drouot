//
//  ListeParametresTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 16/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData



class ListeParametresTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var titre: UINavigationItem!
    
    var parametres = [Parametre]()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantParametreCellule = "celluleParametre"
    
    var idModele = ""
    
//ViewLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        titre.title="Liste de Paramètres"
        

        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                //self.delData()
                
                initParametre(parametreString:"Temperature")
                initParametre(parametreString:"PH")
                initParametre(parametreString:"Acidité")
                initParametre(parametreString:"Durée")
                initParametre(parametreString:"Intrant")
                

                
            }
            //print("Debug : /viewDidLoad/fin")
            

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
            print("DEBUG: parametresLoad/fetch performed")
            
        }
   
//InitParametre
        func initParametre(parametreString:String){
            fetchResults()

            
            if let parametres = fetchedResultsController.fetchedObjects{
                if parametres.count < 5 {
                    //print("DEBUG: /initParametre/parametres.count < 5 ")
                    
                    //Initialisation des Parametres
                    var newParametre = NSEntityDescription.insertNewObject(forEntityName: "Parametre", into:persistentContainer.viewContext)
                    newParametre.setValue(parametreString, forKey: "nom")
 
                    
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
                    //print("DEBUG: /initParamtre/nombre parametre >5 :", parametres.count)
                }
            }
            else {
                print("DEBUG: /initParamtre/fetchedObjects failed :", parametres.count)
                    
            }
            
            
        }
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        
        
    }

    
///Table Views fonctions
    //Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Nombre Ligne
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let parametres = fetchedResultsController.fetchedObjects else { return 0 }
        //print("Debug : /ListParametre/tableView/parametres.count  : ", parametres.count)
        return parametres.count
    }
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantParametreCellule, for: indexPath)
        
        //configureCell
        configureCell(cell, at: indexPath)

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
        fetchedResultsController.delegate = self   //bizarre
        
        return fetchedResultsController
    }()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            print("DEBUG : FetchController/ switch insert")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : FetchController/ switch update")
                configureCell(cell,at : indexPath)
            }
        default :
            print("DEBUG : FetchController/ switch default")
        }
        
    }
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: FetchController/beginUpdates")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("DEBUG: FetchController/endUpdates")
        tableView.endUpdates()

    }
 
///Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Cancel" {
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                print("DEBUG: ListParametre/Cancel/idModele", idModele)
                destinationVC.idModele = idModele
            }
        }
        
    }
    
    
///Autres
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
    

    
    
    

