//
//  CartViewController.swift
//  KioskScanner
//
//  Created by Kenny Pham on 3/2/15.
//  Copyright (c) 2015 InfinitePeripherals. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cartTableView: UITableView!
    var cartString: String = ""
    var cartList: Array<AnyObject> = []
    
    var theCart = [NSManagedObject]()
    
    var productDatabase = [Product(name: "Water bottle", quantity: 1, UPC: "123456789", price: 2.49, imageReference: "water-bottle"), Product(name: "Camera", quantity: 1, UPC: "987654321", price: 199.99, imageReference: "camera"), Product(name: "Play Station 3", quantity: 1, UPC: "113456789", price: 249.99, imageReference: "ps3"), Product(name: "HD 650", quantity: 1, UPC: "223456789", price: 349.99, imageReference: "hd650"), Product(name: "Samsung 850 Pro SSD", quantity: 1, UPC: "123456788", price: 189.99, imageReference: "850pro")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        println("viewDidload: \(self.cartString)")
        
        var nib = UINib(nibName: "itemTableCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        var itemArray = cartString.componentsSeparatedByString("!")
        
        var toReturn = Product()
        //self.saveItem(productDatabase[1])
        
        for (var j=0; j<itemArray.count; j++){
            for (var i=0; i<productDatabase.count; i++){
                if itemArray[j] == productDatabase[i].UPC{
                    //toReturn = database[i]
                    
                    self.saveItem(productDatabase[i])
                }
            }
        }
        
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Cart")
        
        cartList = context.executeFetchRequest(request, error: nil)!
        
        println("cartList \(cartList.count)")
        
        self.cartTableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        //self.cartTableView.editing = true;
        self.cartTableView.reloadData()
        
    }
    
    
    @IBAction func finishPressed(sender: UIButton) {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Cart")
        
        cartList = context.executeFetchRequest(request, error: nil)!
        
        //self.totalLabel.text = "Total: $0.00"
        
        if let tv = cartTableView {
            
            var bas: NSManagedObject!
            
            for bas: AnyObject in cartList
            {
                context.deleteObject(bas as NSManagedObject)
            }
            
            cartList.removeAll(keepCapacity: false)
            tv.reloadData()
            context.save(nil)
            
        }
        
    }
    
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(cartTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(cartTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:itemCell = cartTableView.dequeueReusableCellWithIdentifier("cell") as itemCell
        let item = theCart[indexPath.row]
        var price: Double = 0.0
        
        cell.itemName.text = item.valueForKey("name") as String?
        price = item.valueForKey("price") as Double!
        cell.itemPrice.text = "$\(price)"
        var imageName = item.valueForKey("image") as String?
        cell.itemImage.image = UIImage(named: imageName!)
        
        //cell.itemQuantity.text = item.valueForKey("quantity") as String?
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.cartTableView.beginUpdates()
        self.cartTableView.insertRowsAtIndexPaths(theCart, withRowAnimation: UITableViewRowAnimation.Automatic)
        self.cartTableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 147
    }
    
    
    func saveItem(toAdd: Product) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Cart",
            inManagedObjectContext:
            managedContext)
        
        let item = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        
        //3
        item.setValue(toAdd.name, forKey: "name")
        item.setValue(toAdd.price, forKey: "price")
        item.setValue(toAdd.quantity, forKey: "quantity")
        item.setValue(toAdd.imageReference, forKey: "image")
        item.setValue(toAdd.UPC, forKey: "upc")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        //5
        theCart.append(item)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Cart")
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        if let results = fetchedResults {
            theCart = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
