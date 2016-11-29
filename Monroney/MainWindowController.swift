//
//  MainWindowController.swift
//  Monroney
//
//  Created by Jeffrey Klarfeld on 11/28/16.
//  Copyright © 2016 Jeffrey Klarfeld. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController
{
	// MARK: - Lifecycle
	
	override func awakeFromNib()
	{
		super.awakeFromNib()
		
		guard window != nil else
		{
			print("window was nil at awakeFromNib, aborting...")
			abort()
		}
		
		self.window?.title = Bundle.main.infoDictionary![String(kCFBundleExecutableKey)] as! String
	}
}
