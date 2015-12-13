//
//  Notify.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/10/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
//


import UIKit


class Notify {
	
	class func pine(mensaje: String, contador: Int){
		//let now: NSDateComponents = NSCalendar.currentCalendar().components([.Day], fromDate: NSDate())
		
		
		
		var components = NSDateComponents()
		components.setValue(contador,forComponent: NSCalendarUnit.Day)
		var date : NSDate = NSDate()
		var firedate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
		
		let reminder = UILocalNotification()
		reminder.fireDate = firedate
		reminder.alertBody = mensaje
		reminder.soundName = "sound.aif"
	

		UIApplication.sharedApplication().scheduleLocalNotification(reminder)
		
		

		print(firedate!)
	
	}

	
	
}
