//
//  ParametresAffichageTableViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 17/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData


class ParametresAffichageTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, YourCellDelegate{


    @IBOutlet weak var AddButton: UIBarButtonItem!
    @IBOutlet weak var titreTextField: UITextField!
    

    var parametre = [Parametre]()
    
    //Nom du nouveau parametre à ajouter, donné par la PickerView
    var param:String = ""
    
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    let identifiantParametreCellule = "CelluleParametreAffichage"
    
    /*
     Navigation :
     l'idObjet récupéré permet d'aller chercher cet objet dans la base et de sauvegarder les modifications faites dessus
     le segue passe en argument le nom de l'objet sur lequel on travaille
     la vue suivante récupère le nom de l'objet, le place dans son id et vas le chercher dans la base
     L'objet n-2 (ici modele) fonctionne uniquement avec l'id car l'objet n'est pas chargé car aucune mofiication n'est directement faites dessus
     */
    var idModele:String = ""
    var idModule:String = ""
    var module = Module()
    var modele = Modele()
    var hasParametre:Bool = false
    

    //SUPPRIMER : Action du bouton supprimer
    func didPressButton(cell:CelluleTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        // print("DEBUG : /Module / didPressButton / index path  :", indexPath?.row)
        
        let parametre = fetchedResultsController.object(at: indexPath!)
        
        // print("DEBUG : /Module / didPressButton / modele : ", module.nom)
        parametre.managedObjectContext?.delete(parametre)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titreTextField.text = idModule
        print("Paramètres-----------------from : ", idModule)
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
               self.recupModele()
                self.recupModule()
                self.fetchResults()
                print("DEBUG: /Parametre / ViewLoad / fetchController, count : ", self.fetchedResultsController.fetchedObjects?.count)
            }
            //print("Debug : /Parametre/viewDidLoad/fin")
        }
        
    }
    

//tableView functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nombreLignes = fetchedResultsController.fetchedObjects?.count  else {return 0}
        return nombreLignes
    }
    
    //Remplissage cellule
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifiantParametreCellule, for: indexPath)  as? CelluleTableViewCell else
        {
            print("DEBUG : /Parametre/Cellule/ cellule de mauvais type")
            //On return un truc de base
            return UITableViewCell()
        }
        let parametre = fetchedResultsController.object(at: indexPath)
        
        //intialisaiton cellule
        cell.cellDelegate = self
        
        //configuration cellule
        cell.configure(cell, at: indexPath, parametre:parametre)
        
        
        return cell
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
        //print("DEBUG: /Parametre/fetchResults/fetch performed")
        
    }
 
///Creation objet Parametre
    func newParametre(nomNewParametre:String) {
        fetchResults()
        
        print("DEBUG: /Parametre/newParametre/ param : ", nomNewParametre)
        
        //Creation du parametre
        var newParametre = NSEntityDescription.insertNewObject(forEntityName: "Parametre", into:persistentContainer.viewContext)
        newParametre.setValue("newParametre", forKey: "nom")
        
        //Utilisation du nom temporaire newParametre pour l'identifié lors de l'association au module
        
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
    
    
///Association au Module
    func associationAuModule(nomNewParametre:String)
    {
        fetchResults()
        
        ///Recuperation du nouveau parametre
        //fecth request
        let fetchRequestParametre: NSFetchRequest<Parametre> = Parametre.fetchRequest()
        let predicate = NSPredicate(format: "nom == %@", "newParametre")
        fetchRequestParametre.predicate = predicate
        

        if let parametres = try? persistentContainer.viewContext.fetch(fetchRequestParametre){
                if (parametres.count != 1)
                {
                    print("DEBUG : /Parametre /  Association au Module / Erreur : newParamtre différents de 1 :", parametres.count)
                }
                else {
                    //Récuperation du parametre
                    let parametre:Parametre = parametres[0]
                    print("DEBUG : /Parametre /  Association au Module / parametre nom : ", parametre.nom)
                    //Setup du nouveau nom du parametre
                    parametre.nom = nomNewParametre
                    //Setup du lien avec le module
                    module.addToParametres(parametre)
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
    
///Recup modele
    func recupModele() {
        //Recup du modele passé en parametre dans le view controller
        // Création Fetch Request
        let fetchRequestModele: NSFetchRequest<Modele> = Modele.fetchRequest()
        let predicate = NSPredicate(format: "nom = %@", idModele)
        fetchRequestModele.predicate = predicate
        
        //Parcours des modeles pour récuperer le bon modele
        if let modeles = try? persistentContainer.viewContext.fetch(fetchRequestModele)
        {
            if (modeles.count != 1) {
                print("DEBUG: /parametre/recupModele/WARNING : nombre de modele différents de 1")
            }
            else {
                modele = modeles[0]
                print("DEBUG: /parametre/recupModele/modele recupere : ", modele.nom)
                
            }
        }
        else {print("DEBUG:  /parametre/recupModele/fetchRequest MODELE failed")}
    }

///RecupModule
    func recupModule() {
        
        //Recup du modele passé en parametre dans le view controller
        // Création Fetch Request
        let fetchRequestModule: NSFetchRequest<Module> = Module.fetchRequest()
        let predicate = NSPredicate(format: "nom = %@ AND modele.nom = %@", argumentArray: [idModule, idModele])
        fetchRequestModule.predicate = predicate
        
        //Parcours des modeles pour récuperer le bon modele
        if let modules = try? persistentContainer.viewContext.fetch(fetchRequestModule)
        {
            for moduleParcours in (modules){
                print("DEBUG : FetchController / moduleParocurs : ",moduleParcours.nom)
            }
            if (modules.count != 1) {
                print("DEBUG: /parametre/recupModule/WARNING : nombre de module différents de 1", modules.count)
            }
            else {
                module = modules[0]
                print("DEBUG: /parametre/recupModele/modele recupere : ", module.nom)
                
            }
        }
        else {print("DEBUG:  /parametre/recupModele/fetchRequest MODULE failed")}
    }
    
    
///FetchedController
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Parametre> = {
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Parametre> = Parametre.fetchRequest()
        
        // Paramétrage Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        
        //Ajout d'un predicate pour spécifier la request
        let predicate = NSPredicate(format: "module.nom == %@ ", idModule )
        fetchRequest.predicate=predicate
        
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
            print("DEBUG : /Parametre/FetchController/ INSERT")
            break
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("DEBUG : /Parametre/FetchController/ UPDATE")
                let parametre = fetchedResultsController.object(at: indexPath)
                cell.textLabel?.text = parametre.nom
            }
        case .delete :
            print("DEBUG : /Module/FetchController/ DELETE : indexPath :", indexPath?.row)
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            print("DEBUG : /ModUle/FetchController/ DELETE")
        default :
            print("DEBUG : /Parametre/FetchController/ DEFAULT")
        }
        
    }
    
    //fonctions d'updates du controleur
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("DEBUG: /Parametre/FetchController/beginUpdates")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("DEBUG: /Parametre/FetchController/endUpdates")
        tableView.endUpdates()
        
    }
    
///Segue functions
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var disponible:Bool = true
        
        print("DEBUG / segue/ should / text==Field", titreTextField.text)
        
        switch titreTextField.text {
        //Modele nouvellement crée dont le nom doit etre changé
        case "newModule" :
            titreTextField.textColor = UIColor.red
            print("DEUBG op :  /module/Segue/textField deja utilisé")
            disponible  = false
            break
        //Le nom du modele n'a pas été modifié
        case idModule:
            titreTextField.textColor = UIColor.black
           print("DEUBG op :  /module/Segue/textField = idModele")
            break
        //Le nom du modele a été modifié et nécessite une verification de disponibilité
        default :
            if ( verificationDisponibilitéNomModule(nom: titreTextField.text!))
            {
                //Le nouveau nom est disponible
                titreTextField.textColor = UIColor.green
                self.module.nom = titreTextField.text
                print("DEUBG op :  /module/SeguetextField changé et dispo")
                
                //Sauvegarde
                do {
                    try persistentContainer.viewContext.save()
                    print("PersistentContainer saved")
                } catch {
                    print("Unable to Save Changes")
                    print("\(error), \(error.localizedDescription)")
                }
                
            }
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

        if segue.identifier == "AddParametre" {
            fetchResults()
            
            if let destinationVC = segue.destination as? SelectionParametreViewController{
                print("DEBUG: Parametre/segueAddParametre/idModele", idModele)
                print("DEBUG: Parametre/segueAddParametre/idModule", module.nom)
                destinationVC.idModele = modele.nom!
                destinationVC.idModule = module.nom!
            }
        }
        if segue.identifier == "Cancel" {
             if let destinationVC = segue.destination as? ModulesAffichageTableViewController {
                destinationVC.idModele = modele.nom!
                
            }
        }
        if segue.identifier == "ModifyParametre" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return }
            let parametre = fetchedResultsController.object(at: indexPath)
            
            if let destinationVC = segue.destination as? SelectionParametreViewController {
                destinationVC.idModele = modele.nom!
                destinationVC.idModule = module.nom!
            }
            else{
                print("DEBUG: /Parametre/ segueAction/ definition du segue destination failed")
            }
        }
        
    }
    
///Autres
    override func viewWillDisappear(_ animated: Bool) {
        fetchResults()
        do {
            try persistentContainer.viewContext.save()
            print("PersistentContainer saved")
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        fetchResults()
        
        if (hasParametre == true) {
            hasParametre=false
           // print("DEBUG op : /parametre/Appear/Parametre existant")
            newParametre(nomNewParametre:param)
            associationAuModule(nomNewParametre: param)
        }

        
    }


 
    func verificationDisponibilitéNomModule(nom:String) -> Bool{
        var estDisponible:Bool  = true
        //Recup des modeles existants
        // Création Fetch Request
        let fetchRequestModule: NSFetchRequest<Module> = Module.fetchRequest()
        
        //Parcours des modeles pour récuperer le bon modele
        if let modules = try? persistentContainer.viewContext.fetch(fetchRequestModule)
        {
            for moduleParcours in modules {
                //Si le nom entrée dans le textField est déja utilisé par un modèle
                if moduleParcours.nom == nom {
                    // print("DEBUG:  /module/recupModele/ modele match :", modeleParcours.nom)
                    estDisponible = false
                }
            }
        }
        else {print("DEBUG:  /parametre/verificationDisponibilitéNomModele/fetchRequest MODELE failed")}
        return estDisponible
        
    }
    
}




