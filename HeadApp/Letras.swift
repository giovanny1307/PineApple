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
	
	
	
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		var tag: Int = tableView.cellForRowAtIndexPath(indexPath)!.tag
		
		ud.setValue(tag, forKey:"Letra")
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		self.tableView.reloadData()
		
	}
	
	
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		var ud: NSUserDefaults = NSUserDefaults.standardUserDefaults()
		
		cell.accessoryType = UITableViewCellAccessoryType.None
		
		if(ud.integerForKey("Letra") == cell.tag ){
			
			
			print(ud.integerForKey("Letra"))
			cell.accessoryType = UITableViewCellAccessoryType.Checkmark
			
		}
	}

}
