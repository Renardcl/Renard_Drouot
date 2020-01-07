//
//  ModulesAffichageTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 17/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

class ModulesAffichageTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, YourCellDelegate {

    //Outlets
    @IBOutlet weak var titre: UINavigationItem!
    @IBOutlet weak var AddButton: UIBarButtonItem!
    @IBOutlet weak var titreTextField: UITextField!
    
    //Action du bouton supprimer
    func didPressButton(cell:CelluleTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        ///print("DEBUG : /Module / didPressButton / index path  :", indexPath?.row)
        let module = fetchedResultsController.object(at: indexPath!)
        ///print("DEBUG : /Module / didPressButton / modele : ", module.nom)
        module.managedObjectContext?.delete(module)
    }
    
    //Variables de manipulation des objets
    var module = [Module]()
    var modele = Modele()
    
    //PersistentContainer
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    //Identifiant Cellule
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
        
        print("Modules-----------------")

        titreTextField.text = idModele
        
        //Chargement du coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("ERROR : Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                //Recuperation du modèle passé en paramètre
                self.recupModele()
                self.fetchResults()
            }
        }
    }
 
    
///tableView functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nombreLignes = fetchedResultsController.fetchedObjects?.count else {return 0}
        return nombreLignes
    }
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifiantModuleCellule, for: indexPath)  as? CelluleTableViewCell else
        {
            print("WARNING : /Module/Cellule/ cellule de mauvais type")
            //On return un truc de base
            return UITableViewCell()
        }
        
        let module = fetchedResultsController.object(at: indexPath)
        
        //Utilisation d'un protocol Delegate pour le configuration de la cellule
        cell.cellDelegate = self
        cell.configure(cell, at: indexPath, module:module)
        
        return cell
    }

    
///Creation object Modele
    func newModule(){
        fetchResults()  //USefull??
        
        //Recuperation des modules
        if let modules = fetchedResultsController.fetchedObjects{
            
            //Initialisation du nouveahu module : newModule
            var newModule = NSEntityDescription.insertNewObject(forEntityName: "Module", into:persistentContainer.viewContext)
            newModule.setValue("newModule", forKey: "nom")
            
            //Sauvegarde et chargement des nouvelles valeurs
            saveContext()
            fetchResults()
        }
        else {
            print("ERROR: /Module/newModule/fetchedObjects Failed")
        }
    }
    
    
///Association du nouveau Module(newModule) au Modele
    func associationAuModele()
    {
        fetchResults()
        
        //Recuperation du nouveau module : newModule avec une Request ciblant son nom
        let fetchRequestModule: NSFetchRequest<Module> = Module.fetchRequest()
        let predicate = NSPredicate(format: "nom == %@", "newModule")
        fetchRequestModule.predicate = predicate
        
        if let modules = try? persistentContainer.viewContext.fetch(fetchRequestModule){
            if (modules.count != 1) {
                print("WARNING: /Module/Association au Modele / WARNING : nombre de module récupéré différents de 1 :", modules.count)
            }
            else {
                //Attribution du module recuperé précédement au modèle
                modele.addToModules(modules[0])
                ///print("DEBUG: /Module/Association au Modele /module recupere : ", module.nom)
            }
        
            //Sauvegarde et chargement des nouvelles valeurs
            saveContext()
            fetchResults()
        }
    }

///Recuperation du modèle passé en paramètre
    func recupModele() {
        //Recup du modele passé en parametre dans le view controller
        // Création Fetch Request
        let fetchRequestModele: NSFetchRequest<Modele> = Modele.fetchRequest()
        let predicate = NSPredicate(format: "nom == %@", idModele)
        fetchRequestModele.predicate = predicate
        
        //Parcours des modeles pour récuperer le bon modele
        if let modeles = try? persistentContainer.viewContext.fetch(fetchRequestModele)
        {
            if (modeles.count != 1) {
                print("WARNING: /Module/Recup Modèle/ WARNING : nombre de modele récupéré différents de 1", modeles.count)
            }
            else {
                modele = modeles[0]
                ///print("WARNING: /Module/Recup Modèle/ modele récupéré : ", modele.nom)
            }
        }
        else {print("ERROR :  /module/recupModele/fetchRequest MODELE failed")}
    }
    
    
    
    
///FetchedController
        //Definition du FetchController : Request / Predicate / Instanciation / delegate
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
    
    //FetchResult
    func fetchResults(){
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("ERROR : Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    
    //Fonctions CRUD du Controller
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type){
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            ///print("DEBUG : /Module/FetchController/ INSERT")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                let module = fetchedResultsController.object(at: indexPath)
                cell.textLabel?.text = module.nom
            }
            ///print("DEBUG : /Module/FetchController/ UPDATE")
        case .delete :
                if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            ////print("DEBUG : /Module/FetchController/ DELETE : indexPath :", indexPath?.row)
        default :
         print("DEBUG : /Module/FetchController/ DEFAULT")
        }
    }
    
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ///print("DEBUG: /Module/FetchController/beginUpdates")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ///print("DEBUG: /Module/FetchController/endUpdates")
        tableView.endUpdates()
    }
    
    
///Segue functions
    //Controles a effectué avant de pouvoir effectuer le Segue
    //Test si le nom du module présent dans le textField est disponible, deja utilisé(doublon), non-modifié ou vient d'être créé : newModule
        //TODO : Message à l'utilisateur
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var disponible:Bool = true
        
        switch titreTextField.text {
            
        //Modèle nouvellement crée dont le nom doit etre changé
        case "newModele" :
            titreTextField.textColor = UIColor.red
            print("ERROR :  /module/Segue/textField deja utilisé")
            disponible  = false
            break
            
        //Le nom du modèle n'a pas été modifié
        case idModele:
            titreTextField.textColor = UIColor.black
            break
            
        //Le nom du modèle a été modifié et nécessite une verification de disponibilité
        default :
            if ( verificationDisponibilitéNomModele(nom: titreTextField.text!))
            {
                //Le nouveau nom est disponible
                titreTextField.textColor = UIColor.green
                
                //Il est attribué au modèle
                modele.nom = titreTextField.text
                
                //On sauvegarde
                saveContext()
            }
            else
            {
                //Le nouveau nom est indisponible
                titreTextField.textColor = UIColor.red
                disponible  = false
            }
            break
        }
        return disponible
    }
    
    //Passage d'argument dans les segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddModule" {
            //On crée un nouveau module
            newModule()
            
            //On l'associe au modele précédement grace a son nom "newModule"
            associationAuModele()
            
            ///print("DEBUG: /Module/ segueAction/ avant passage parametre nouveau module : ", modele.nom)`
            
            //Argument : nom du modèle + "newModule"
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                destinationVC.idModele =  modele.nom!
                destinationVC.idModule = "newModule"
            }
            else{
                print("ERROR : /Module/ segueAction/ definition du segue destination failed")
            }
        }
        
       /* if segue.identifier == "Cancel" {
        }*/
        
        if segue.identifier == "ModifyModule" {
            //Récuperation du module sur lequel on a cliqué
            guard let indexPath = tableView.indexPathForSelectedRow else {return }
            let module = fetchedResultsController.object(at: indexPath)
            
            //Argument : nom du modèle + nom du module
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                 ///print("DEBUG: /Module/ segueAction/ modify modele : ", modele.nom)
                 ///print("DEBUG: /Module/ segueAction/ modify  module : ", module.nom)
                destinationVC.idModele = modele.nom!
                destinationVC.idModule = module.nom!
                
            }
            else{
                print("ERROR : /Module/ segueAction/ definition du segue destination failed")
            }
        }
        
    }
    
    
///Autres
    //Verification de disponibilité de nom de modèle lorsqu'il est modifié dans le textField
    func verificationDisponibilitéNomModele(nom:String) -> Bool{
        var estDisponible:Bool  = true
        
        //Recup des modeles existants
        //Création Fetch Request
        let fetchRequestModele: NSFetchRequest<Modele> = Modele.fetchRequest()
        
        //Parcours des modeles pour tester les noms
        if let modeles = try? persistentContainer.viewContext.fetch(fetchRequestModele)
        {
            for modeleParcours in modeles {
                //Si le nom entrée dans le textField est déja utilisé par un modèle
                if modeleParcours.nom == nom {
                    ///print("DEBUG:  /module/VerifDispo/ modele match :", modeleParcours.nom)
                    estDisponible = false
                }
            }
        }
        else {print("ERROR :  /module/verificationDisponibilitéNomModele/fetchRequest MODELE failed")}
        return estDisponible
    }
    
    //Fetch d'anticipation
    override func viewWillAppear(_ animated: Bool)
    {
        fetchResults()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        fetchResults()
        saveContext()
    }

    
    //Fonctions de sauvegarde
    func saveContext()
    {
        do {
            try persistentContainer.viewContext.save()
            print("PersistentContainer saved")
        } catch {
            print("ERROR : Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }
}
