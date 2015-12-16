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
import QuartzCore





class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,TableViewCellDelegate, UINavigationControllerDelegate,UITextViewDelegate {


	@IBOutlet weak var tableViewPine: UITableView!
	
	@IBOutlet weak var alturaText: NSLayoutConstraint!
	
	
	

	@IBAction func Share(sender: UIButton) {
		
		let textToShare = "HeadApp is awesome!"
		
		
			let objectsToShare = [textToShare]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			
			//New Excluded Activities Code
			//activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
			//
			
			self.presentViewController(activityVC, animated: true, completion: nil)
		
	}

	@IBOutlet weak var inputUsuario: UITextView!
	
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var hightInputLayout: NSLayoutConstraint!
	
	var CoreDatos = [NSManagedObject]()
	var texto = String()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		var app: UIApplication = UIApplication.sharedApplication()
		
		var eventArray: [UILocalNotification] = app.scheduledLocalNotifications!
		print("PRUEBA INICIAL   \(eventArray.count)!!!!!!!!!!!!!!!!!!!!!!")
		
		if CoreDatos.count>0{return}
		
		//declaracion de delegados y datasource para table view
		self.navigationController?.delegate = self
		self.tableViewPine.delegate = self
		self.tableViewPine.dataSource = self
		tableViewPine.registerClass(TableViewCell.self, forCellReuseIdentifier: "MensajeUsuario")
		
		//listener para el texfield es decir un delegate, para reconocer cuando el usuario hizo tap en el 
		
		self.inputUsuario.delegate = self
		self.inputUsuario.layer.cornerRadius = 5
		
		self.inputUsuario.scrollEnabled =  false
		
		
		//Color y estilo de la tableView
		
		let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
		self.tableViewPine.addGestureRecognizer(tapGesture)
		
		
		tableViewPine.separatorStyle = .None
		tableViewPine.backgroundColor = UIColor(red:0.85, green:0.88, blue:0.90, alpha:1.0)
	
		self.tableViewPine.reloadData()
		navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.33, blue:0.51, alpha:1.0)
		navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		
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
	
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.tableViewPine.reloadData()
	}
	
	//MARK: Input usuario y tap gesture
	
	
	func tableViewTapped(){
	
		self.inputUsuario.endEditing(true)
		
	}
	
	@IBAction func sendButtonTab(sender: UIButton) {
		
		
		
		//BajarTeclado
		
		self.inputUsuario.endEditing(true)
		
		//input usuario
		
		if(inputUsuario.text!.isEmpty || inputUsuario.text == ""){
			
			return
			
		}else{
		
		saveMessage(inputUsuario.text!)
		tableViewPine.reloadData()
		
	
		//Activar notificaciones
		
		metodoPine()
		
		//Borrar teclado
		
		inputUsuario.text = ""
		

		}
		
	
	}
	
	
	
	
	//MARK: TextField delegados
	
	func textViewDidBeginEditing(textView: UITextView) {
		self.view.layoutIfNeeded()
		
		
	
		
		UIView.animateWithDuration(0.5, animations: {
			
			self.hightInputLayout.constant = 315
			
			
			self.view.layoutIfNeeded()
			
			
			}, completion: nil)
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		
		self.view.layoutIfNeeded()
		UIView.animateWithDuration(0.5, animations: {
			
			self.hightInputLayout.constant = 44
			self.alturaText.constant = 30
	
			
			self.view.layoutIfNeeded()
			
			
			}, completion: nil)
		

	}
	
	
	func textViewDidChange(textView: UITextView) {
		
		var alturaDinamica = inputUsuario.sizeThatFits(CGSizeMake(inputUsuario.frame.size.width ,  100))
		
				hightInputLayout.constant = 315 + alturaDinamica.height - 35
				alturaText.constant = alturaDinamica.height
		        self.view.layoutIfNeeded()

	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		let currentCharacterCount = textView.text?.characters.count ?? 0
		if (range.length + range.location > currentCharacterCount){
			return false
		}
		let newLength = currentCharacterCount + text.characters.count - range.length
		return newLength <= 64
	}
	
	
	
	
	//MARK: delegados celdas
	
	
	
	func toDoItemDeleted(todoItem: NSManagedObject) {
		
		
		

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
		// reprogramar notificacions
		
		if(CoreDatos.count>1){
		
			metodoPine()}
		
		// Cancel notifications 
		
		
		if (CoreDatos.count == 0){
			cancelNotifications()
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
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		cell.textLabel?.numberOfLines = 0
		cell.textLabel!.text = mensaje.valueForKey("name") as? String
		cell.textLabel!.font = tipoletra()
		cell.textLabel?.textColor = UIColor.whiteColor()
		cell.textLabel?.backgroundColor = UIColor.clearColor()

		cell.delegate = self
		cell.toDoItem = mensaje
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	
	//MARK: Metodo para el color 
	
	func colorForIndex(index: Int) -> UIColor {
		
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		var eleccion: Int = ud.integerForKey("Color")
		let itemCount = CoreDatos.count - 1
		let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
		var esquema = UIColor()

		
			switch eleccion
			{ case 1 : esquema = UIColor(red: val , green: 0.2 , blue: 0.9 , alpha: 1.0)//HeadApp
			  case 2 : esquema = UIColor(red: 0.0 , green: val , blue: 1.0 , alpha: 1.0)//Blue
			  case 3 : esquema = UIColor(red: 1.0 , green: val , blue: val , alpha: 1.0)//Red
			  case 4 : esquema = UIColor(red: val , green: 0.75 , blue: 0.0 , alpha: 1.0)//Green
			  case 5 : esquema = UIColor(red: 0.8 , green: val , blue: 0.75 , alpha: 1.0)//Pink
			  case 6 : esquema = UIColor(red: 0.5 , green: val , blue: 1.0 , alpha: 1.0)//Violeta
			  case 7 : esquema = UIColor(red: 0.7 , green: 0.7 , blue: 0.7 , alpha: 1.0)//Grey
			  default : esquema = UIColor(red: val , green: 0.2 , blue: 0.9 , alpha: 1.0)//HeadApp
		
			}
		
			
		return esquema	}
 
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
	
// MARK: METODO PINEAPPLE
	
	func metodoPine(){
	var dias = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,
		32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61
		,62,63,64]
		
		if (CoreDatos.count>=1){
	 
		cancelNotifications()
		
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
			}}
		
		

	}
	
	func cancelNotifications(){
		
		var app: UIApplication = UIApplication.sharedApplication()
		var eventArray: [UILocalNotification] = app.scheduledLocalNotifications!
		
		app.cancelAllLocalNotifications()
		print("PRUEBA SISTEMATICA   \(eventArray.count)!!!!!!!!!!!!!!!!!!!!!!")
	
	}
	
	
	//MARK: fuentes
	
	 func tipoletra()->UIFont{
	
		var esquema = UIFont()
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		var eleccion: Int = ud.integerForKey("Letra")
		
		switch eleccion
		{ case 0 : esquema = UIFont(name:"Amatic-Bold",size: 33)!
		case 1 : esquema = UIFont(name:"Bebas",size: 33)!
		case 2 : esquema = UIFont(name:"Captureit",size: 33)!
		case 3 : esquema = UIFont(name:"StarJedi",size: 25)!
		case 4 : esquema = UIFont(name:"Lobster1.3",size: 33)!
		case 5 : esquema = UIFont(name:"UnderwoodChampion",size: 33)!
		case 6 : esquema = UIFont(name:"Avenir",size: 33)!
		default : esquema = UIFont(name:"Avenir",size: 33)!
			
		}
		
		return esquema
	
	}
	
	
	
}






