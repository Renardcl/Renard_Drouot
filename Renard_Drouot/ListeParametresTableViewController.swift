//
//  ListeParametresTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 16/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData



class ListeParametresTableViewController: UITableViewController {
    
    var parametres = [Parametre]()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                initParametre()
            }
            print("Debug : /viewDidLoad/fin")
        }
        
        
        

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
        
        func initParametre(){
            fetchResults()
            
            if let parametres = fetchedResultsController.fetchedObjects{
                if parametres.count == 0 {
                    print("DEBUG: /initParametre/parametres.count = 0 ")
                    
                    //Initialisation des Parametres
                    var newParametre = NSEntityDescription.insertNewObject(forEntityName: "Parametre", into:persistentContainer.viewContext)
                    
                    newParametre.setValue("Temperature", forKey: "nom")
                    
                    //Sauvegarde
                    do {
                        try persistentContainer.viewContext.save()
                        print("PersistentContainer saved")
                    } catch {
                        print("Unable to Save Changes")
                        print("\(error), \(error.localizedDescription)")
                    }
                    
                    fetchResults()
                }
                else {
                    print("DEBUG: /initParamtre/nombre parametre >0 :", parametres.count)
                    
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

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let parametres = fetchedResultsController.fetchedObjects else { return 0 }
        print("Debug : /ListParametre/tableView/parametres.count  : ", parametres.count)
        return self.parametres.count
    }

    
    
    
    
    
    //FetchedController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Parametre> = {
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Parametre> = Parametre.fetchRequest()
        
        // Paramétrage Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        
        // Création Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Paramètrage Fetched Results Controller
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate //bizarre
        
        return fetchedResultsController
    }()
    
    
    
    
    
    
    
    
    
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
