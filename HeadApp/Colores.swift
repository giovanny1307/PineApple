//
//  Colores.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/14/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
//

import UIKit


class Colores: UITableViewController {
	
	@IBOutlet var TablaColores: UITableView!

	@IBOutlet weak var celdaA: UITableViewCell!
	
	@IBOutlet weak var celdaB: UITableViewCell!
	
	@IBOutlet weak var celdaC: UITableViewCell!
	
	@IBOutlet weak var celdaD: UITableViewCell!
	
	@IBOutlet weak var celdaE: UITableViewCell!
	
	@IBOutlet weak var celdaF: UITableViewCell!
	
	@IBOutlet weak var celdaG: UITableViewCell!
	
	@IBOutlet weak var color1: UILabel!
	
	@IBOutlet weak var color2: UILabel!
	
	@IBOutlet weak var color3: UILabel!
	
	@IBOutlet weak var color4: UILabel!
	
	@IBOutlet weak var color5: UILabel!
	
	@IBOutlet weak var color6: UILabel!
	
	@IBOutlet weak var color7: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let ud: UserDefaults = UserDefaults.standard
		let tag: Int = tableView.cellForRow(at: indexPath)!.tag
		
		ud.setValue(tag, forKey:"Color")
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		self.tableView.reloadData()
		
	}
	

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let ud: UserDefaults = UserDefaults.standard
		
		cell.accessoryType = UITableViewCellAccessoryType.none
		
		if(ud.integer(forKey: "Color") == cell.tag ){
			
			
			print(ud.integer(forKey: "Color"))
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
			
		}
	}
	
		
	
	
	}
	
	
	
	
	


