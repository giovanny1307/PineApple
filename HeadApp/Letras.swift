//
//  Letras.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/13/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
//

import UIKit

class Letras: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	
	
	
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let ud: UserDefaults = UserDefaults.standard
		let tag: Int = tableView.cellForRow(at: indexPath)!.tag
		
		ud.setValue(tag, forKey:"Letra")
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		self.tableView.reloadData()
		
	}
	
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let ud: UserDefaults = UserDefaults.standard
		
		cell.accessoryType = UITableViewCellAccessoryType.none
		
		if(ud.integer(forKey: "Letra") == cell.tag ){
			
			
			print(ud.integer(forKey: "Letra"))
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
			
		}
	}

}
