//
//  ListViewController.swift
//  MyFirstCoreDataDemo
//
//  Created by 潘新宇 on 15/8/21.
//  Copyright (c) 2015年 潘新宇. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var people = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        println("\(NSHomeDirectory())")
    }
    
    @IBAction func addBtn(sender: UIBarButtonItem) {
        //声明一个alertVC
        var alertVC = UIAlertController(title: "添加数据", message: "请输入", preferredStyle: UIAlertControllerStyle.Alert)
        //为alertVC添加一个TextField
        alertVC.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in}
        //确认按钮
        var confirmAc = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
            var str = (alertVC.textFields![0] as! UITextField).text
            self.saveData(str)
            if self.people.count != 0{
                var indexPath = NSIndexPath(forRow: self.people.count - 1, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }else{
                self.saveData(str)
                self.tableView.reloadData()
            }
        }
        //取消按钮
        var cancleAc = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default) { (alert:UIAlertAction!) -> Void in
            
        }
        //把按钮添加到alertVC
        alertVC.addAction(confirmAc)
        alertVC.addAction(cancleAc)
        //显示alertVC
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    //view显示时调用的方法
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getData()
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return people.count
    }
    
    //取得ManagedObjectContext的方法
    func getManagedObjContext()->NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        return context!
    }
    
    //保存数据的方法
    func saveData(text:String){
        //获取managedObjContext
        var managedObjContext = getManagedObjContext()
        //定义一个要保存的实体entity
        var entity = NSEntityDescription.entityForName("People", inManagedObjectContext: managedObjContext)!
        //定义一个实体中的实例person
        var person:NSManagedObject = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedObjContext)
        //给实例赋值
        person.setValue(text, forKey: "name")
        //保存managedObjContext
        var error:NSError?
        if !managedObjContext.save(&error){
            println("保存出错！")
        }
        //将实例people添加到数组中
        people.append(person)
    }
    
    //获取数据的方法
    func getData(){
        //获取managedObjContext
        var managedObjContext = getManagedObjContext()
        //定义一个请求
        var request = NSFetchRequest(entityName: "People")
        //获取请求结果
        var error:NSError?
        if let result = managedObjContext.executeFetchRequest(request, error: &error) as? [NSManagedObject]{
            self.people = result
        }else{
            println("获取数据失败，\(error?.userInfo)")
        }
    }


    //cell样式
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        var str = people[indexPath.row].valueForKey("name") as! String
        cell.textLabel?.text = str

        return cell
    }


    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            var managedObjContext = getManagedObjContext()
            managedObjContext.deleteObject(people[indexPath.row])
            var error:NSError?
            managedObjContext.save(&error)
            println(people.count)
            

            
            people.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
