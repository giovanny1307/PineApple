//
//  ViewController.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/1/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
// Dios te salve reina y madre. 

import UIKit
import CoreData
import Foundation
import QuartzCore
import GoogleMobileAds


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,TableViewCellDelegate, UINavigationControllerDelegate,UITextViewDelegate, BWWalkthroughViewControllerDelegate{


	@IBOutlet weak var tableViewPine: UITableView!
	@IBOutlet weak var alturaText: NSLayoutConstraint!
	@IBOutlet weak var inputUsuario: UITextView!
	@IBOutlet weak var sendButton: UIButton!
	@IBOutlet weak var hightInputLayout: NSLayoutConstraint!
	
	@IBOutlet weak var banner: GADBannerView!
	
	var interstitial: GADInterstitial!
	
	var i = 0
	
	var pageViewController: UIPageViewController!
	var pageTitle: NSArray!
	var pageImages: NSArray!
	var CoreDatos = [NSManagedObject]()
	var texto = String()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
		let app: UIApplication = UIApplication.shared
		
		let eventArray: [UILocalNotification] = app.scheduledLocalNotifications!
		print("PRUEBA INICIAL   \(eventArray.count)!!!!!!!!!!!!!!!!!!!!!!")
		
		if CoreDatos.count>0{return}
		
		//declaracion de delegados y datasource para table view
		self.navigationController?.delegate = self
		self.tableViewPine.delegate = self
		self.tableViewPine.dataSource = self
		tableViewPine.register(TableViewCell.self, forCellReuseIdentifier: "MensajeUsuario")
		
		//listener para el texfield es decir un delegate, para reconocer cuando el usuario hizo tap en el 
		
		self.inputUsuario.delegate = self
		self.inputUsuario.layer.cornerRadius = 5
		
		self.inputUsuario.isScrollEnabled =  false
		
		
		//Color y estilo de la tableView
		
		let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tableViewTapped))
		self.tableViewPine.addGestureRecognizer(tapGesture)
		
		
		tableViewPine.separatorStyle = .none
		tableViewPine.backgroundColor = UIColor(red:0.85, green:0.88, blue:0.90, alpha:1.0)
	
		self.tableViewPine.reloadData()
		navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.33, blue:0.51, alpha:1.0)
		navigationController?.navigationBar.tintColor = UIColor.white
		
		//BannerGoogle
		
		self.banner.adUnitID = "ca-app-pub-8311139956951620/8885327591"
		self.banner.rootViewController = self
		let request: GADRequest = GADRequest()
		self.banner.load(request)
		
		
		let ud = UserDefaults.standard
		
		
		
		if (ud.bool(forKey: "HasLaunchedOnce") == false)
		{
			self.tutorial("1" as AnyObject)
			ud.set(true, forKey: "HasLaunchedOnce")
			ud.synchronize()
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
		
  //1
  let appDelegate =
  UIApplication.shared.delegate as! AppDelegate
		
  let managedContext = appDelegate.managedObjectContext
		
  //2
  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
		
  //3
  do {
	let results =
	try managedContext.fetch(fetchRequest)
	CoreDatos = results as! [NSManagedObject]
} catch let error as NSError {
	print("Could not fetch \(error), \(error.userInfo)")
  }
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		metodoPine()
		
		self.tableViewPine.reloadData()
	}
	
	//MARK: Input usuario y tap gesture
	
	
	func tableViewTapped(){
	
		self.inputUsuario.endEditing(true)
		
	}
	
	@IBAction func sendButtonTab(_ sender: UIButton) {
		
		
		
		//BajarTeclado
		
		self.inputUsuario.endEditing(true)
		
		//input usuario
		
			if(inputUsuario.text!.isEmpty || inputUsuario.text == ""){
			
				return
			
			}else{
				
				i += 1
				saveMessage(inputUsuario.text!)
				tableViewPine.reloadData()
				//Activar notificaciones
				metodoPine()
				//Borrar teclado
				inputUsuario.text = ""
		}
		
	
	}
	
	
	
	
	//MARK: TextField delegados
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		self.view.layoutIfNeeded()
		
		
	
		
		UIView.animate(withDuration: 0.5, animations: {
			
			self.hightInputLayout.constant = 315
			
			
			self.view.layoutIfNeeded()
			
			
			}, completion: nil)
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		
		self.view.layoutIfNeeded()
		UIView.animate(withDuration: 0.5, animations: {
			
			self.hightInputLayout.constant = 100
			self.alturaText.constant = 30
	
			
			self.view.layoutIfNeeded()
			
			
			}, completion: nil)
		

	}
	
	
	func textViewDidChange(_ textView: UITextView) {
		
		let alturaDinamica = inputUsuario.sizeThatFits(CGSize(width: inputUsuario.frame.size.width ,  height: 100))
		
				hightInputLayout.constant = 315 + alturaDinamica.height - 35
				alturaText.constant = alturaDinamica.height
		        self.view.layoutIfNeeded()

	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let currentCharacterCount = textView.text?.characters.count ?? 0
		if (range.length + range.location > currentCharacterCount){
			return false
		}
		let newLength = currentCharacterCount + text.characters.count - range.length
		return newLength <= 64
	}
	
	//MARK: delegados celdas
	
	func toDoItemDeleted(_ todoItem: NSManagedObject) {
		
		
		

		let index = (CoreDatos as NSArray).index(of: todoItem)
		if index == NSNotFound { return }
		
  // could removeAtIndex in the loop but keep it here for when indexOfObject works

		let appDell : AppDelegate = UIApplication.shared.delegate as! AppDelegate
		let context : NSManagedObjectContext = appDell.managedObjectContext
		
		context.delete(CoreDatos[index] as NSManagedObject)
		CoreDatos.remove(at: index)
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
		UIView.animate(withDuration: 0.3, delay: delay, options: UIViewAnimationOptions(),
			animations: {() in
				cell.frame = cell.frame.offsetBy(dx: 0.0,
					dy: -cell.frame.size.height)},
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
		cell.isHidden = true
	}
  }
		
  // use the UITableView to animate the removal of this row
  tableViewPine.beginUpdates()
  let indexPathForRow = IndexPath(row: index, section: 0)
  tableViewPine.deleteRows(at: [indexPathForRow], with: .fade)
  tableViewPine.endUpdates()
		
		
	}
	
	//MARK: Boton share
	
	@IBAction func Share(_ sender: UIButton) {
		
		let textToShare = "http://itunes.apple.com/app/idcom.goblent.HeadAppa"
		
		
		let objectsToShare = [textToShare]
		let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
		
		//New Excluded Activities Code
		//activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
		//
		
		self.present(activityVC, animated: true, completion: nil)
		
	}
	
	//MARK: delegados del tableView
	//metodos del extend o delegate para que la table view funcione
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return CoreDatos.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "MensajeUsuario", for: indexPath) as! TableViewCell
		cell.selectionStyle = .none
		let mensaje = CoreDatos[indexPath.row]
		cell.textLabel?.lineBreakMode = .byWordWrapping
		cell.textLabel?.numberOfLines = 0
		cell.textLabel!.text = mensaje.value(forKey: "name") as? String
		cell.textLabel!.font = tipoletra()
		cell.textLabel?.textColor = UIColor.white
		cell.textLabel?.backgroundColor = UIColor.clear

		cell.delegate = self
		cell.toDoItem = mensaje
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	//MARK: Metodo para el color 
	
	func colorForIndex(_ index: Int) -> UIColor {
		
		let ud: UserDefaults = UserDefaults.standard
		let eleccion: Int = ud.integer(forKey: "Color")
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
 
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
		forRowAt indexPath: IndexPath) {
			cell.backgroundColor = colorForIndex(indexPath.row)
	}
	
	// MARK: - add, delete, edit methods
	
	
	func saveMessage(_ name: String) {
  //1
  let appDelegate =
  UIApplication.shared.delegate as! AppDelegate
		
  let managedContext = appDelegate.managedObjectContext
		
  //2
  let entity =  NSEntityDescription.entity(forEntityName: "Person",in:managedContext)
		
  let person = NSManagedObject(entity: entity!,insertInto: managedContext)
		
  //3
  person.setValue(name, forKey: "name")
		
  //4
  do {
	try managedContext.save()
	//5
	CoreDatos.insert(person,at: 0)
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
			var a = dias.remove(at: numeroMsj)
			var arrayCount2 = UInt32(CoreDatos.count)
			var randomNumber2 = arc4random_uniform(arrayCount2)
			var numeroMsj2 =  Int(randomNumber2)
			var mensaje = CoreDatos[numeroMsj2].value(forKey: "name") as? String
			
			Notify.pine(mensaje!, contador: a)
			}}
		
		

	}
	
	func cancelNotifications(){
		
		let app: UIApplication = UIApplication.shared
		let eventArray: [UILocalNotification] = app.scheduledLocalNotifications!
		
		app.cancelAllLocalNotifications()
		print("PRUEBA SISTEMATICA   \(eventArray.count)!!!!!!!!!!!!!!!!!!!!!!")
	
	}
	
	
	//MARK: fuentes
	
	 func tipoletra()->UIFont{
	
		var esquema = UIFont()
		let ud: UserDefaults = UserDefaults.standard
		let eleccion: Int = ud.integer(forKey: "Letra")
		
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
	
	//MARK: tutorial
	
	
	
	@IBAction func tutorial(_ sender: AnyObject) {
		
		let stb = UIStoryboard(name:"Main", bundle: nil)
		
		let walk = stb.instantiateViewController(withIdentifier: "page0") as! BWWalkthroughViewController
		
		
		let page_one = stb.instantiateViewController(withIdentifier: "page1") as UIViewController
		
		let page_two = stb.instantiateViewController(withIdentifier: "page2") as UIViewController
		
		let page_tree = stb.instantiateViewController(withIdentifier: "page3") as UIViewController
		
		
		walk.delegate = self
		walk.addViewController(page_one)
		walk.addViewController(page_two)
		walk.addViewController(page_tree)
		
		
		
		self.present(walk, animated: true, completion: nil)
	}
	
	func walkthroughCloseButtonPressed() {
		self.dismiss(animated: true, completion: nil)
	}
}






