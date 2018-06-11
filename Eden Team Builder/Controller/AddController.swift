//
//  AddController.swift
//  Eden Team Builder
//
//  Created by Sébastien Gilabert on 16/05/2018.
//  Copyright © 2018 Sébastien Gilabert. All rights reserved.
//

import UIKit
import RealmSwift

class AddController: UIViewController
{
    static let ADDCONTROLLER_VIEW_ID = "addController"
    
    @IBOutlet weak var imageView: UIImageView!
    var orderedViewControllers : [UIViewController] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let pageViewController = self.parent as! PageViewController
        orderedViewControllers = pageViewController.orderedViewControllers
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let alert = UIAlertController(title: "Profil", message: "Voulez-vous ajouter un nouveau profil ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { action in
            let profilFormController = self.storyboard?.instantiateViewController(withIdentifier: "profilView") as! ProfilFormViewController
            
            let perso = Personnage()
            
            /*
            let realm = try! Realm()
            try! realm.write {
                realm.add(perso)
            }
            */
            
            profilFormController.model = perso
            profilFormController.update = false
            profilFormController.parentController = self.parent as! PageViewController
            self.navigationController?.show(profilFormController, sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
