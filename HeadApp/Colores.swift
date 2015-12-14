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
	
	
	
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		var tag: Int = tableView.cellForRowAtIndexPath(indexPath)!.tag
		
		ud.setValue(tag, forKey:"Color")
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		self.tableView.reloadData()
		
	}
	

	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		
		cell.accessoryType = UITableViewCellAccessoryType.None
		
		if(ud.integerForKey("Color") == cell.tag ){
			
			
			print(ud.integerForKey("Color"))
			cell.accessoryType = UITableViewCellAccessoryType.Checkmark
			
		}
	}
	
		
	
	
	}
	
	
	
	
	


