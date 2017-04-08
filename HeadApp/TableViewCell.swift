//
//  TableViewCell.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/3/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
//

import UIKit
import CoreData

// A protocol that the TableViewCell uses to inform its delegate of state change
protocol TableViewCellDelegate {
	// indicates that the given item has been deleted
	func toDoItemDeleted(_ todoItem: NSManagedObject)
}

class TableViewCell: UITableViewCell {
	
	

	let gradientLayer = CAGradientLayer()
	var originalCenter = CGPoint()
	var deleteOnDragRelease = false
	// The object that acts as delegate for this cell.
	var delegate: TableViewCellDelegate?
	// The item that this cell renders.
	var toDoItem: NSManagedObject?
 
	required init(coder aDecoder: NSCoder) {
		fatalError("NSCoding not supported")
	}
 
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		// gradient layer for cell
		gradientLayer.frame = bounds
		let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor as CGColor
		let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor as CGColor
		let color3 = UIColor.clear.cgColor as CGColor
		let color4 = UIColor(white: 0.0, alpha: 0.1).cgColor as CGColor
		gradientLayer.colors = [color1, color2, color3, color4]
		gradientLayer.locations = [0.0, 0.01, 0.95, 1.0]
		layer.insertSublayer(gradientLayer, at: 0)
		
		let recognizer = UIPanGestureRecognizer(target: self, action: #selector(TableViewCell.handlePan(_:)))
		recognizer.delegate = self
		addGestureRecognizer(recognizer)
	}
 
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = bounds
	}
	
	//MARK: - horizontal pan gesture methods
	func handlePan(_ recognizer: UIPanGestureRecognizer) {
  // 1
  if recognizer.state == .began {
	// when the gesture begins, record the current center location
	originalCenter = center
  }
  // 2
  if recognizer.state == .changed {
	let translation = recognizer.translation(in: self)
	center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
	// has the user dragged the item far enough to initiate a delete/complete?
	deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
  }
  // 3
  if recognizer.state == .ended {
	let originalFrame = CGRect(x: 0, y: frame.origin.y,
		width: bounds.size.width, height: bounds.size.height)
	if deleteOnDragRelease {
		if delegate != nil && toDoItem != nil {
			// notify the delegate that this item should be deleted
			delegate!.toDoItemDeleted(toDoItem!)
		}
	} else {
		UIView.animate(withDuration: 0.1, animations: {self.frame = originalFrame})
	}
		}
	
	
}
	
	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
			let translation = panGestureRecognizer.translation(in: superview!)
			if fabs(translation.x) > fabs(translation.y) {
				return true
			}
			return false
		}
		return false
	}
	


}
