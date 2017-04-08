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
		let ud: UserDefaults = UserDefaults.standard
		
		if(ud.string(forKey: "Nombre") == nil){return}else{
			self.Name.placeholder = ud.string(forKey: "Nombre")!}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let ud: UserDefaults = UserDefaults.standard
		if(ud.string(forKey: "Nombre") == nil){return}else{
			self.Name.placeholder = ud.string(forKey: "Nombre")!}
	}
	
	//MARK: input
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		Name.resignFirstResponder()
		accion()
		
		return true
	}
	
	func accion(){
		
		let ud: UserDefaults = UserDefaults.standard
		let nombre = Name.text!
		
		
		ud.setValue(nombre, forKey: "Nombre")
		
		
		
		Name.placeholder = ud.string(forKey: "Nombre")!
		
		print("EL NOMBRE ES:\(Name.placeholder!)!!!!!!!!!!!!!!!!!!!!!")
		

		
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		
		tv.deselectRow(at: indexPath, animated: true)
		
	}
	
	

}
