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
    
    var parametres = [Parametre]()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantParametreCellule = "celluleParametre"
    
//ViewLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                initParametre(parametreString:"Temperature")
                initParametre(parametreString:"PH")
                initParametre(parametreString:"Acidité")
                initParametre(parametreString:"Durée")
                initParametre(parametreString:"Intrant")
                
            }
            print("Debug : /viewDidLoad/fin")
            
           //self.delData()
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
                if parametres.count <= 5 {
                    print("DEBUG: /initParametre/parametres.count < 5 ")
                    
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
                    print("DEBUG: /initParamtre/nombre parametre >5 :", parametres.count)
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
        print("Debug : /ListParametre/tableView/parametres.count  : ", parametres.count)
        return parametres.count
    }
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantParametreCellule, for: indexPath)
        
        //configureCell
        configureCell(cell, at: indexPath)
        
       /* if let parametres = fetchedResultsController.fetchedObjects
        {
            print("DEBUG : ListeParametres/tableView/cellForRowAt/Recuperation parametres ok : ", parametres.count)
            
            let indexRow = indexPath.row
            print ("DEBUG : indexpath : ", indexPath.row)
            cell.textLabel?.text = "\(parametres[indexRow].nom)"
        }
        else {
            print("DEBUG : ListeParametres/tableView/cellForRowAt/Erreur dans recuperation de parametres")
        }*/

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
    
    

    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//suprression data :
/*
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
*/
