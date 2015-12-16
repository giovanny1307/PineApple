//
//  Ajustes.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/14/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
//


import UIKit

class Ajustes: UITableViewController,UITextFieldDelegate {
	
	

	
	@IBOutlet weak var Name: UITextField!
	
	@IBOutlet var tv: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.Name.delegate  = self
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		
		if(ud.stringForKey("Nombre") == nil){return}else{
			self.Name.placeholder = ud.stringForKey("Nombre")!}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		
		
		if(ud.stringForKey("Nombre") == nil){return}else{
			self.Name.placeholder = ud.stringForKey("Nombre")!}
		
		
	}
	

	
	//MARK: input
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		Name.resignFirstResponder()
		accion()
		
		return true
	}
	
	func accion(){
		
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		var nombre = Name.text!
		
		
		ud.setValue(nombre, forKey: "Nombre")
		
		
		
		Name.placeholder = ud.stringForKey("Nombre")!
		
		print("EL NOMBRE ES:\(Name.placeholder!)!!!!!!!!!!!!!!!!!!!!!")
		

		
	}
	
	override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		
		tv.deselectRowAtIndexPath(indexPath, animated: true)
		
	}
	
	

}
