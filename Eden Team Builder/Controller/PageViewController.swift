//
//  PageViewController.swift
//  Eden Team Builder
//
//  Created by Sébastien Gilabert on 15/03/2018.
//  Copyright © 2018 Sébastien Gilabert. All rights reserved.
//

import UIKit
import RealmSwift

class PageViewController: UIPageViewController, UIPageViewControllerDelegate
{
    @IBOutlet var navigationBar: UINavigationItem!
    var modifyButtonItem: UIBarButtonItem!
    
    var pageControl = UIPageControl()
    var pageControlIndex = 0
    var pageControlSetup = false
    var storyBoard: UIStoryboard?
    
    var orderedViewControllers : [UIViewController] = []
    var persos: Results<Personnage>!
    var isSetup = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dataSource = nil
        dataSource = self
        self.delegate = self
        
        storyBoard = UIStoryboard(name: "Main", bundle: nil)
        modifyButtonItem = navigationBar.rightBarButtonItem!
        
        let realm = try! Realm()

        /*
        try! realm.write {
            realm.deleteAll()
        }
        */
        
        persos = realm.objects(Personnage.self)
        
        orderedViewControllers.removeAll()
        for perso in persos
        {
            let persoController: PersonnageController = storyBoard?.instantiateViewController(withIdentifier: PersonnageController.PERSONNAGE_VIEW_ID) as! PersonnageController
            
            persoController.model = perso
            orderedViewControllers.append(persoController)
        }
        
        let addController: AddController = storyBoard?.instantiateViewController(withIdentifier: AddController.ADDCONTROLLER_VIEW_ID) as! AddController
        
        orderedViewControllers.append(addController)
        
        if orderedViewControllers.count == 1
        {
            modifyButtonItem.isEnabled = false
        }
        
        if(isSetup == false)
        {
            if let firstViewController = orderedViewControllers.first
            {
                setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            }
            isSetup = true
        }
        else
        {
            setViewControllers([orderedViewControllers.first!], direction: .reverse, animated: false, completion: nil)
            
            setViewControllers([orderedViewControllers[pageControlIndex]], direction: .forward, animated: false, completion: nil)
        }
        
        configurePageControl()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    
        if Mirror(reflecting: orderedViewControllers[pageControl.currentPage]).subjectType == PersonnageController.self
        {
            navigationBar.title = (orderedViewControllers[pageControl.currentPage] as! PersonnageController).model!.nom
            modifyButtonItem.isEnabled = true
        }
        else
        {
            navigationBar.title = orderedViewControllers.last!.title!
            modifyButtonItem.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configurePageControl()
    {
        if self.pageControlSetup == false
        {
            pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
            
            self.pageControl.numberOfPages = orderedViewControllers.count
            self.pageControl.currentPage = pageControlIndex
            self.pageControl.tintColor = UIColor.black
            self.pageControl.pageIndicatorTintColor = UIColor.darkGray
            self.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
            self.pageControl.hidesForSinglePage = true
            
            self.view.addSubview(pageControl)
            self.view.willRemoveSubview(pageControl)
            self.pageControlSetup = true
        }
        else
        {
            self.pageControl.removeFromSuperview()
            pageControlSetup = false
            self.configurePageControl()
        }
    }
    // MARK: - Delegate function
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
        
//        print(Mirror(reflecting: orderedViewControllers[pageControl.currentPage]).subjectType)
        
        if Mirror(reflecting: orderedViewControllers[pageControl.currentPage]).subjectType == AddController.self
        {
            navigationBar.title = orderedViewControllers.last?.title
            modifyButtonItem.isEnabled = false
        }
        else
        {
            let persoController: PersonnageController = pageContentViewController as! PersonnageController
            navigationBar.title = persoController.model?.nom
            modifyButtonItem.isEnabled = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)
    {
        // Create a new variable to store the instance of PlayerTableViewController
        if segue.identifier == "profilSegue"
        {
            let destinationVC = segue.destination as! ProfilFormViewController
            destinationVC.parentController = self
            destinationVC.model = (orderedViewControllers[pageControl.currentPage] as! PersonnageController).model
        }
    }
}

extension PageViewController : UIPageViewControllerDataSource
{
    func pageViewController( _ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else
        {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else
        {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController( _ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        
        //let nextIndex = viewControllerIndex + 1
       // let nextIndex = pageControlIndex + 1
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
 
        return orderedViewControllers[nextIndex]
    }
}
