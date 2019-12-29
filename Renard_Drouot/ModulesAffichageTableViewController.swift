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
    @IBOutlet weak var titreTextField: UITextField!
    
    
    var module = [Module]()
    
    var modele = Modele()
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantModuleCellule = "CelluleModuleAffichage"
    
    /*
     Navigation :
     l'idObjet récupéré permet d'aller chercher cet objet dans la base et de sauvegarder les modifications faites dessus
     le segue passe en argument le nom de l'objet sur lequel on travaille
     la vue suivante récupère le nom de l'objet, le place dans son id et vas le chercher dans la base
     */
    var idModele:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titreTextField.text = idModele
        print("DEBUG: /module/ViewLoad/idModele-----------------", idModele)

        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                //self.delData()

                self.recupModele()
                self.fetchResults()
                
            }
            //print("Debug : /viewDidLoad/fin")
        }
        
    }
 
    
///tableView functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nombreLignes = modele.modules?.count else {return 0}
        return nombreLignes
    }
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiantModuleCellule, for: indexPath)
        
        //configureCell
        configureCell(cell, at: indexPath)

        return cell
    }

    
    func configureCell(_ cell: UITableViewCell, at indexPath : IndexPath){

        var modules = modele.modules?.allObjects as! [Module]
        
        if (modules.count > 1) {
            modules = trier(liste:modules)
        }
        
        
        cell.textLabel?.text = modules[indexPath.row].nom
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

    
///Creation object Modele
    func newModule(){
        fetchResults()
        
        if let modules = fetchedResultsController.fetchedObjects{
            //print("DEBUG: /Module/newModule/modules fetched OK ")
            
            //Initialisation des Parametres
            var newModule = NSEntityDescription.insertNewObject(forEntityName: "Module", into:persistentContainer.viewContext)
            newModule.setValue("newModule", forKey: "nom")
            
            
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
            print("DEBUG: /Module/newModule/fetchedObjects Failed")
        }
        //print("DEBUG: /Modele/NewModele/fin new Modele")
    }
    
    
///Association au Modele
    func associationAuModele()
    {
        fetchResults()
        
        ///Recuperation du nouveau module
        //fecth request
        let fetchRequestModule: NSFetchRequest<Module> = Module.fetchRequest()
        
        //Recuperation des modules du persistent container
        if let modules = try? persistentContainer.viewContext.fetch(fetchRequestModule){
            var module:Module
            //print("DEBUG: /Module/association au Modele/module recup ")
            
            //Parcours des modules pour récuperer le bon module
            for moduleParcours in modules {
                if moduleParcours.nom == "newModule" {
                    //Recuperation du module dans module
                    module = moduleParcours
                    
                    
                    //Attribution du module recuperé précédement au modèle
                    modele.addToModules(module)

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
        
            //Chargement des nouvelles valeurs
            fetchResults()

        }
    }

///Recup modele
    func recupModele() {
        //Recup du modele passé en parametre dans le view controller
        // Création Fetch Request
        let fetchRequestModele: NSFetchRequest<Modele> = Modele.fetchRequest()
        
        //Parcours des modeles pour récuperer le bon modele
        if let modeles = try? persistentContainer.viewContext.fetch(fetchRequestModele)
        {
            for modeleParcours in modeles {
                if modeleParcours.nom == idModele {
                   // print("DEBUG:  /module/recupModele/ modele match :", modeleParcours.nom)
                    //Recuperation du modele
                    modele = modeleParcours
                    
                }
            }
        }
        else {print("DEBUG:  /module/recupModele/fetchRequest MODELE failed")}
        
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
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            print("DEBUG : /Module/FetchController/ INSERT")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : /Module/FetchController/ UPDATE")
                configureCell(cell,at : indexPath)
            }
        case .delete :
            print("DEBUG : /ModUle/FetchController/ DELETE")
        
        default :
         print("DEBUG : /Module/FetchController/ DEFAULT")
        }
        
    }
    
    
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // print("DEBUG: /Module/FetchController/beginUpdates")
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // print("DEBUG: /Module/FetchController/endUpdates")
        tableView.endUpdates()
        
    }
    
    
///Segue functions
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var disponible:Bool = true
        
        switch titreTextField.text {
        //Modele nouvellement crée dont le nom doit etre changé
        case "newModele" :
            titreTextField.textColor = UIColor.red
            print("DEUBG op :  /module/Segue/textField deja utilisé")
            disponible  = false
            break
        //Le nom du modele n'a pas été modifié
        case idModele:
            titreTextField.textColor = UIColor.black
            print("DEUBG op :  /module/Segue/textField = idModele")
            break
        //Le nom du modele a été modifié et nécessite une verification de disponibilité
        default :
            if ( verificationDisponibilitéNomModele(nom: titreTextField.text!))
            {
                //Le nouveau nom est disponible
                titreTextField.textColor = UIColor.green
                modele.nom = titreTextField.text
                print("DEUBG op :  /module/SeguetextField changé et dispo")
                
                //Sauvegarde
                do {
                    try persistentContainer.viewContext.save()
                    print("PersistentContainer saved")
                } catch {
                    print("Unable to Save Changes")
                    print("\(error), \(error.localizedDescription)")
                }        }
            else
            {
                //Le nouveau nom est indisponible
                titreTextField.textColor = UIColor.red
                print("DEUBG op :  /module/Segue/textField deja utilisé")
                disponible  = false
            }
            break
        }
            return disponible
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        fetchResults()
        
        if segue.identifier == "AddModule" {
            //On crée un nouveau module
            newModule()
            
            //On l'associe au modele précédement grace a son nom "newModule"
            associationAuModele()
            
            print("DEBUG: /Module/ segueAction/ avant passage parametre nouveau module : ", modele.nom)
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                destinationVC.idModele =  modele.nom!
                destinationVC.idModule = "newModule"
            }
            else{
                print("DEBUG: /Module/ segueAction/ definition du segue destination failed")
            }
        }
        
        if segue.identifier == "Cancel" {
        }
        
        if segue.identifier == "ModifyModule" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return }
            //let moduleS = fetchedResultsController.object(at: indexPath)
            //Recuperation des modules du modele
            var  modules = modele.modules?.allObjects as! [Module]
            //Trie des modules pour correspondre aux index de la tableView
            if (modules.count > 1) {
                modules = trier(liste:modules)
            }
            //REcuperation du modele clické
            let module = modules[indexPath.row]

            
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                 print("DEBUG: /Module/ segueAction/ modify modele : ", modele.nom)
                 print("DEBUG: /Module/ segueAction/ modify  module : ", module.nom)
                destinationVC.idModele = modele.nom!
                destinationVC.idModule = module.nom!
                
            }
            else{
                print("DEBUG: /Module/ segueAction/ definition du segue destination failed")
            }
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


    
    override func viewWillAppear(_ animated: Bool)
    {
        fetchResults()
        
    }
    
    
    
    func trier(liste:[Module]) ->[Module] {
        var listeTrié:[Module] = liste
        var tmp:Module
        var trié:Bool = false
        while (trié == false) {
            trié = true
            for j in 0...listeTrié.count-2 {
                if listeTrié[j+1].nom! < listeTrié[j].nom! {
                    tmp = listeTrié[j+1]
                    listeTrié[j+1] = listeTrié[j]
                    listeTrié[j] = tmp
                    trié = false
                }
            }
                
        }
        return listeTrié
    }
    
    func verificationDisponibilitéNomModele(nom:String) -> Bool{
        var estDisponible:Bool  = true
        //Recup des modeles existants
        // Création Fetch Request
        let fetchRequestModele: NSFetchRequest<Modele> = Modele.fetchRequest()
        
        //Parcours des modeles pour récuperer le bon modele
        if let modeles = try? persistentContainer.viewContext.fetch(fetchRequestModele)
        {
            for modeleParcours in modeles {
                //Si le nom entrée dans le textField est déja utilisé par un modèle
                if modeleParcours.nom == nom {
                    // print("DEBUG:  /module/recupModele/ modele match :", modeleParcours.nom)
                    estDisponible = false
                }
            }
        }
        else {print("DEBUG:  /module/verificationDisponibilitéNomModele/fetchRequest MODELE failed")}
        return estDisponible
    }
}
