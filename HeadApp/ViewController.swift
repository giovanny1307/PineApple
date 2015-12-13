//
//  ViewController.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/1/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TableViewCellDelegate {
	

	@IBOutlet weak var tableViewPine: UITableView!
	@IBOutlet weak var inputUsuario: UITextField!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var hightInputLayout: NSLayoutConstraint!
	
	
	var CoreDatos = [NSManagedObject]()
	var texto = String()
	var i = 0
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		var app: UIApplication = UIApplication.sharedApplication()
		var eventArray: [UILocalNotification] = app.scheduledLocalNotifications!
		print("PRUEBA INICIAL   \(eventArray.count)!!!!!!!!!!!!!!!!!!!!!!")
		
		if CoreDatos.count>0{return}
		
		//declaracion de delegados y datasource para table view
		
		self.tableViewPine.delegate = self
		self.tableViewPine.dataSource = self
		tableViewPine.registerClass(TableViewCell.self, forCellReuseIdentifier: "MensajeUsuario")
		
		//listener para el texfield es decir un delegate, para reconocer cuando el usuario hizo tap en el 
		
		self.inputUsuario.delegate = self
		
		//Color y estilo de la tableView
		
		tableViewPine.separatorStyle = .None
		tableViewPine.backgroundColor = UIColor.blackColor()
		tableViewPine.rowHeight = 50.0
		
		
	}
	
	override func viewWillAppear(animated: Bool) {
  super.viewWillAppear(animated)
		
  //1
  let appDelegate =
  UIApplication.sharedApplication().delegate as! AppDelegate
		
  let managedContext = appDelegate.managedObjectContext
		
  //2
  let fetchRequest = NSFetchRequest(entityName: "Person")
		
  //3
  do {
	let results =
	try managedContext.executeFetchRequest(fetchRequest)
	CoreDatos = results as! [NSManagedObject]
} catch let error as NSError {
	print("Could not fetch \(error), \(error.userInfo)")
  }
	}
	
	//MARK: Input usuario
	
	@IBAction func sendButtonTab(sender: UIButton) {
		
		var dias = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,
			32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61
			,62,63,64]
		
		var app: UIApplication = UIApplication.sharedApplication()
		var eventArray: [UILocalNotification] = app.scheduledLocalNotifications!
		i = CoreDatos.count
		//BajarTeclado
		
		self.inputUsuario.endEditing(true)
		
		//input usuario
		
		saveMessage(inputUsuario.text!)
		tableViewPine.reloadData()
		 i++
		
		print("Contador send button = \(i)")
		
		//Activar notificaciones
			app.cancelAllLocalNotifications()
			
			while dias.count>0 {
				
				var arrayCount = UInt32(dias.count)
				var randomNumber = arc4random_uniform(arrayCount)
				var numeroMsj =  Int(randomNumber)
				var a = dias.removeAtIndex(numeroMsj)
				var arrayCount2 = UInt32(CoreDatos.count)
				var randomNumber2 = arc4random_uniform(arrayCount2)
				var numeroMsj2 =  Int(randomNumber2)
				var mensaje = CoreDatos[numeroMsj2].valueForKey("name") as? String
				
				Notify.pine(mensaje!, contador: a)
			}

		print("notificaciones programadas piñe test : \(eventArray.count)")

		//Borrar teclado
		
		inputUsuario.text = ""
		
		// Reiniciar contador
		
		if(CoreDatos.count == 0){
			i = 0
		}
	
	}
	
	
	
	//MARK: TextField delegados
	
	func textFieldDidBeginEditing(textField: UITextField) {
		
		self.view.layoutIfNeeded()
		UIView.animateWithDuration(0.5, animations: {
			
			self.hightInputLayout.constant = 320
			self.view.layoutIfNeeded()
			
			
			}, completion: nil)
		
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		self.view.layoutIfNeeded()
		UIView.animateWithDuration(0.5, animations: {
			
			self.hightInputLayout.constant = 70
			self.view.layoutIfNeeded()
			
			
			}, completion: nil)
	}
	
	//MARK: delegados celdas
	
	
	
	func toDoItemDeleted(todoItem: NSManagedObject) {
		
		var app: UIApplication = UIApplication.sharedApplication()
		var eventArray: [UILocalNotification] = app.scheduledLocalNotifications!
		i = CoreDatos.count
		i--
		print("Contador delete method = \(i)")

		let index = (CoreDatos as NSArray).indexOfObject(todoItem)
		if index == NSNotFound { return }
		
  // could removeAtIndex in the loop but keep it here for when indexOfObject works

		let appDell : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		let context : NSManagedObjectContext = appDell.managedObjectContext
		
		context.deleteObject(CoreDatos[index] as NSManagedObject)
		CoreDatos.removeAtIndex(index)
		//context.save(nil)
		
		do {
			try context.save()
		} catch {
			print(error)
		}
		
		if(CoreDatos.count == 0){
			i = 0
		}
		
		if (i == 0){
		
			app.cancelAllLocalNotifications()
			print("notificaciones programadas piñe test 3 : \(eventArray.count)")

	
		}
		
	
	
		
		
  // loop over the visible cells to animate delete
  
	let visibleCells = tableViewPine.visibleCells as! [TableViewCell]
	let lastView = visibleCells[visibleCells.count - 1] as TableViewCell
	var delay = 0.0
	var startAnimating = false
	for i in 0..<visibleCells.count {
	let cell = visibleCells[i]
		if startAnimating {
		UIView.animateWithDuration(0.3, delay: delay, options: .CurveEaseInOut,
			animations: {() in
				cell.frame = CGRectOffset(cell.frame, 0.0,
					-cell.frame.size.height)},
			completion: {(finished: Bool) in
				if (cell == lastView) {
					self.tableViewPine.reloadData()
				}
			}
		)
		delay += 0.03
	}
	if cell.toDoItem === todoItem {
		startAnimating = true
		cell.hidden = true
	}
  }
		
  // use the UITableView to animate the removal of this row
  tableViewPine.beginUpdates()
  let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
  tableViewPine.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
  tableViewPine.endUpdates()
		
		if(i==0){
		
			
		}
	}
	
	
	
	//MARK: delegados del tableView
	//metodos del extend o delegate para que la table view funcione
	
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return CoreDatos.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("MensajeUsuario", forIndexPath: indexPath) as! TableViewCell
		cell.selectionStyle = .None
		let mensaje = CoreDatos[indexPath.row]
		cell.textLabel!.text = mensaje.valueForKey("name") as? String
		cell.textLabel?.backgroundColor = UIColor.clearColor()
		cell.delegate = self
		cell.toDoItem = mensaje
		return cell
	}
	
	
	//MARK: Metodo para el color 
	
	func colorForIndex(index: Int) -> UIColor {
		let itemCount = CoreDatos.count - 1
		let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
		return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
	}
 
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
		forRowAtIndexPath indexPath: NSIndexPath) {
			cell.backgroundColor = colorForIndex(indexPath.row)
	}
	
	
	// MARK: - add, delete, edit methods
	
	
	func saveMessage(name: String) {
  //1
  let appDelegate =
  UIApplication.sharedApplication().delegate as! AppDelegate
		
  let managedContext = appDelegate.managedObjectContext
		
  //2
  let entity =  NSEntityDescription.entityForName("Person",inManagedObjectContext:managedContext)
		
  let person = NSManagedObject(entity: entity!,insertIntoManagedObjectContext: managedContext)
		
  //3
  person.setValue(name, forKey: "name")
		
  //4
  do {
	try managedContext.save()
	//5
	CoreDatos.insert(person,atIndex: 0)
} catch let error as NSError  {
	print("Could not save \(error), \(error.userInfo)")
  }
	}
	
	

	
	
	
}

	
	



