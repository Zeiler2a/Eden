//
//  PersonnageController.swift
//  Eden Team Builder
//
//  Created by Sébastien Gilabert on 19/03/2018.
//  Copyright © 2018 Sébastien Gilabert. All rights reserved.
//

import UIKit

class PersonnageController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    static let PERSONNAGE_VIEW_ID = "personnageId"
    
    var model: Personnage? = nil
    
    @IBOutlet weak var modifyBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleCard: UILabel!
    @IBOutlet weak var profilView: UIImageView!
    @IBOutlet weak var factionView: UIImageView!
    
    @IBOutlet weak var psyValueView: UILabel!
    @IBOutlet weak var vigValueView: UILabel!
    @IBOutlet weak var cbtValueView: UILabel!
    @IBOutlet weak var rapValueView: UILabel!
    
    @IBOutlet weak var psyCP2: UIImageView!
    @IBOutlet weak var psyCP3: UIImageView!
    @IBOutlet weak var psyCP4: UIImageView!
    @IBOutlet weak var psyCP5: UIImageView!
    @IBOutlet weak var psyCP6: UIImageView!
    @IBOutlet weak var psyCP7: UIImageView!
    
    @IBOutlet weak var vigCP2: UIImageView!
    @IBOutlet weak var vigCP3: UIImageView!
    @IBOutlet weak var vigCP4: UIImageView!
    @IBOutlet weak var vigCP5: UIImageView!
    @IBOutlet weak var vigCP6: UIImageView!
    @IBOutlet weak var vigCP7: UIImageView!
    
    @IBOutlet weak var cbtCP2: UIImageView!
    @IBOutlet weak var cbtCP3: UIImageView!
    @IBOutlet weak var cbtCP4: UIImageView!
    @IBOutlet weak var cbtCP5: UIImageView!
    @IBOutlet weak var cbtCP6: UIImageView!
    @IBOutlet weak var cbtCP7: UIImageView!
    
    @IBOutlet weak var rapCP2: UIImageView!
    @IBOutlet weak var rapCP3: UIImageView!
    @IBOutlet weak var rapCP4: UIImageView!
    @IBOutlet weak var rapCP5: UIImageView!
    @IBOutlet weak var rapCP6: UIImageView!
    @IBOutlet weak var rapCP7: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*//Permet de reconaitre le tap sur la photo
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(takePhoto(tapGestureRecognizer:)))
        profilView.isUserInteractionEnabled = true
        profilView.addGestureRecognizer(tapGestureRecognizer)
        //modifyBarButtonItem.action = #selector(buttonModifyClicked(sender:))
        */
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if model != nil
        {
             titleCard.text = model!.nom
            
             //Si il y a Valeur Rouge pour le Psy
             if model!.psyRed == 0
             {
             psyValueView.text = String(model!.psy)
             }
             else
             {
             let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.white]
             
             let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.red]
             
             let attributedString1 = NSMutableAttributedString(string: "\(model!.psy)", attributes:attrs1)
             
             let attributedString2 = NSMutableAttributedString(string:"/\(model!.psyRed)", attributes:attrs2)
             
             attributedString1.append(attributedString2)
             self.psyValueView.attributedText = attributedString1
             }
            
             //Si il y a Valeur Rouge pour la Vig
             if model!.vigRed == 0
             {
             vigValueView.text = String(model!.vig)
             }
             else
             {
             let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.white]
             
             let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.red]
             
             let attributedString1 = NSMutableAttributedString(string: "\(model!.vig)", attributes:attrs1)
             
             let attributedString2 = NSMutableAttributedString(string:"/\(model!.vigRed)", attributes:attrs2)
             
             attributedString1.append(attributedString2)
             self.vigValueView.attributedText = attributedString1
             }
             
             //Si il y a Valeur Rouge pour le CBT
             if model!.cbtRed == 0
             {
             cbtValueView.text = String(model!.cbt)
             }
             else
             {
             let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.white]
             
             let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.red]
             
             let attributedString1 = NSMutableAttributedString(string: "\(model!.cbt)", attributes:attrs1)
             
             let attributedString2 = NSMutableAttributedString(string:"/\(model!.cbtRed)", attributes:attrs2)
             
             attributedString1.append(attributedString2)
             self.cbtValueView.attributedText = attributedString1
             }
            
             //Si il y a Valeur Rouge pour la RAP
             if model!.rapRed == 0
             {
             rapValueView.text = String(model!.rap)
             }
             else
             {
             let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.white]
             
             let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.red]
             
             let attributedString1 = NSMutableAttributedString(string: "\(model!.rap)", attributes:attrs1)
             
             let attributedString2 = NSMutableAttributedString(string:"/\(model!.rapRed)", attributes:attrs2)
             
             attributedString1.append(attributedString2)
             self.rapValueView.attributedText = attributedString1
             }
        }
        
        switch model!.faction
        {
        case .ISC:
            factionView.image = #imageLiteral(resourceName: "isc")
        case .Bamaka:
            factionView.image = #imageLiteral(resourceName: "bamakas")
        default:
            factionView.image = #imageLiteral(resourceName: "jokers")
        }
        
        profilView.image = UIImage(data: (model!.image))
        
         //Génération de PC
         let properties = ["psy", "cbt", "vig", "rap"]
         for i in 2...7
         {
             for property in properties
             {
                 let PCView =  self.value(forKey: "\(property)CP\(i)") as! UIImageView
                
                 if model!.value(forKey: "\(property)CP") as! Int >= i
                 {
                    PCView.image = #imageLiteral(resourceName: "PC-blanc")
                    PCView.isHidden = false
                 }
                 else if model!.value(forKey: "\(property)CPRed") as! Int >= i
                 {
                    PCView.image = #imageLiteral(resourceName: "PC-rouge")
                    PCView.isHidden = false
                 }
                 else
                 {
                    PCView.isHidden = true
                 }
             }
         }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc func takePhoto(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    /*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        profilView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let data = UIImagePNGRepresentation(profilView!.image!)
        {
            let filename = self.getDocumentsDirectory().appendingPathComponent("profil.png")
            try? data.write(to: filename)
        }
    }
 */
    
    /*
    @objc func buttonModifyClicked(sender: UIBarButtonItem)
    {
        print("Hello")
    }
    */
 }
