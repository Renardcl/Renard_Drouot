//
//  UtilisationModeleTableViewController.swift
//  Renard_Drouot
//
//  Created by Clément Renard on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

class UtilisationModeleTableViewController: UITableViewController , NSFetchedResultsControllerDelegate, UtilisationCellDelegate {

    func textFieldChanged(cell : UtilisationModeleTableViewCell, reel:Bool) {
        let indexPath = tableView.indexPath(for: cell)
        // print("DEBUG : /Module / didPressButton / index path  :", indexPath?.row)
        
        let moduleChanged = listModules[(indexPath?.section)!]

        //Recup du modele passé en parametre dans le view controller
        // Création Fetch Request
        let fetchRequestParametre: NSFetchRequest<Parametre> = Parametre.fetchRequest()
        let predicate = NSPredicate(format: "module.nom = %@",  moduleChanged.nom!)
        fetchRequestParametre.predicate = predicate
        
        //Parcours des modeles pour récuperer le bon modele
        if let listParametrefetched = try? persistentContainer.viewContext.fetch(fetchRequestParametre) as [Parametre]
        {
            if (reel == false) {
                listParametrefetched[(indexPath?.row)!].theorique = cell.TheoriqueTextField.text
            }
            else {
                listParametrefetched[(indexPath?.row)!].reel = cell.ReelTextField.text
                
            }
        }
        else {print("DEBUG:  /UT-Modele / TextFieldChanged / fetchRequest MODULE failed")}
        
        //Save
        do {
            try persistentContainer.viewContext.save()
            print("PersistentContainer saved")
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
    }
    
    
    @IBOutlet weak var titre: UINavigationItem!
    
    var modele = Modele()
    var module = Module()
    var listModules:[Module] = [Module]()
    var parametre = Parametre()
    var listParametres:[Parametre] = [Parametre]()

    
    @IBOutlet weak var ValiderButton: UIBarButtonItem!
    @IBAction func ValiderActionButton(_ sender: Any) {
        //TODO : enregistrer textField en BDD
        //Inutile pour l'instant
    }
    
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantUtilisationModeleCellule = "CelluleUtilisationModeleAffichage"  
    
    var idModele:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Utilisation Modèles-------------------------------------------------")
        titre.title = idModele
        
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                self.fetchResults()
                self.initModele()
                self.recupModule()
            
            }
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
        //print("DEBUG: /Modules/fetchResult/fetch performed")
        
    }
    
    
///tableView functions
    //Section
        //Nombre
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (modele.modules?.count)!
    }
    
        //Header Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print("DEBUG /UT-Modele/tableView/SectionHeaderTitle : " ,section)
        let fullHeader:String = listModules[section].nom! + "                  Théorique     Reel"  //TODO remplacer par une View
        return fullHeader
        
    }
    
    /*override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor.red
        
        return vw
    }*/
    
    
        //Header Height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
        
    }
    

    //Ligne
        //Nombre
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (listModules[section].parametres?.count)!
    }
    
        //Remplissage
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifiantUtilisationModeleCellule, for: indexPath)  as? UtilisationModeleTableViewCell else
        {
            print("DEBUG : /Module/Cellule/ cellule de mauvais type")
            //On return un truc de base
            return UITableViewCell()
        }
        
        let module = listModules[indexPath.section]
        let parametres:[Parametre] = fetchParametresFromModule(idModule: module.nom!)

         //intialisaiton cellule
         cell.cellDelegate = self
         
         //configuration cellule
        cell.configure(cell, at: indexPath, parametre:parametres[indexPath.row])
        
        return cell
    }
    
    
    
    
    
///Recup modele
    func initModele() {
        //Recup du modele passé en parametre dans le view controller
        // Création Fetch Request
        
        if let modeles = fetchedResultsController.fetchedObjects
        {
            if (modeles.count > 1) {print("WARNING : Modele recupéré superieur a 1")}
            for modeleParcours in modeles
            {
                if modeleParcours.nom == idModele {
                    // print("DEBUG:  /module/recupModele/ modele match :", modeleParcours.nom)
                    //Recuperation du modele
                    modele = modeleParcours
                    
                }
            }
        }
        else {print("DEBUG:  /UT-modele/recupModele/fetchRequest MODELE failed")}
        
    }

///Recup Module
    func recupModule() {
        
        //Recup du modele passé en parametre dans le view controller
        // Création Fetch Request
        let fetchRequestModule: NSFetchRequest<Module> = Module.fetchRequest()
        let predicate = NSPredicate(format: "modele.nom = %@",  idModele)
        fetchRequestModule.predicate = predicate
        
        //Parcours des modeles pour récuperer le bon modele
        if let listModulesfetched = try? persistentContainer.viewContext.fetch(fetchRequestModule)
        {
            //DEBUG : Affichage
            for moduleParcours in (listModulesfetched){
                //print("DEBUG : FetchController / moduleParocurs : ",moduleParcours.nom)
            }
            if (listModules.count != 1) {
                //print("DEBUG: /UT-Modele/recupModule/Nombre de modules recuprere : ", listModules.count)
            }
            listModules = listModulesfetched
        }
        else {print("DEBUG:  /UT-Modele/recupModule/fetchRequest MODULE failed")}
    }
    
    
///FetchedController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Modele> = {
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Modele> = Modele.fetchRequest()
        
        // Paramétrage Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        
        //Ajout d'un predicate pour spécifier la request
        let predicate = NSPredicate(format: "nom == %@", idModele)
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
    
    func fetchParametresFromModule(idModule:String) -> [Parametre]{
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Parametre> = Parametre.fetchRequest()
    
        // Paramétrage Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
    
        //Ajout d'un predicate pour spécifier la request
        let predicate = NSPredicate(format: "module.nom == %@ ", idModule)
        fetchRequest.predicate=predicate
    
        guard let parametresFetched = try? persistentContainer.viewContext.fetch(fetchRequest) else
        {
            print("DEBUG : /UT-Modele / FetchParametres / ERROR : fetchParametes from module")
            return [Parametre]()
        }
        
        if (parametresFetched.count != 1)
        {
            //print("DEBUG : /UT-Modele / FetchParametres /  Nombre de parameter :", parametresFetched.count)
        }
        
        return parametresFetched
    }
    
///Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "UseModele" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return }
            let modele = fetchedResultsController.object(at: indexPath)
            
            if let destinationVC = segue.destination as? UtilisationModeleTableViewController
            {
                //print("DEBUG : /modele / segueAction / modele.nom : ", modele.nom)
                destinationVC.idModele = modele.nom!
            }
        }
    }
}
