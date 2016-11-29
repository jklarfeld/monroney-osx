//
//  MainWindowController.swift
//  Monroney
//
//  Created by Jeffrey Klarfeld on 11/28/16.
//  Copyright © 2016 Jeffrey Klarfeld. All rights reserved.
//

import Cocoa
import WebKit

class MainWindowController: NSWindowController
{
	// MARK: - Properties
	
	@IBOutlet private weak var vinField: NSTextField?
	
	private weak var webView: WKWebView?
	
	private static let baseURL = URL(string: "https://admin.porschedealer.com/reports/build_sheets/print.php")!
	
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
		
		setupWebView()
	}
	
	// MARK: Setup
	
	private func setupWebView()
	{
		let webView = WKWebView(frame: NSRect.zero)
		webView.translatesAutoresizingMaskIntoConstraints = false
		
		window!.contentView!.addSubview(webView)
		self.webView = webView
		
		webView.topAnchor.constraint(equalTo: vinField!.bottomAnchor, constant: 20.0).isActive = true
		webView.leftAnchor.constraint(equalTo: window!.contentView!.leftAnchor, constant: 0).isActive = true
		webView.rightAnchor.constraint(equalTo: window!.contentView!.rightAnchor, constant: 0).isActive = true
		webView.bottomAnchor.constraint(equalTo: window!.contentView!.bottomAnchor, constant: 0).isActive = true
	}
	
	// MARK: - Instance Methods
	
	private func loadOptions()
	{
		if !validateVIN()
		{
			return
		}
		
		let vin = vinField!.stringValue
		
		let vinQuery = URLQueryItem(name: "vin", value: vin)
		
		var components = URLComponents(url: MainWindowController.baseURL, resolvingAgainstBaseURL: true)
		components?.queryItems = [vinQuery]
		
		let url = components?.url
		
		guard url != nil else
		{
			showInvalidVINAlert()
			return
		}
		
		let request = URLRequest(url: url!)
		
		webView!.load(request)
	}
	
	private func validateVIN() -> Bool
	{
		guard vinField?.stringValue != nil && vinField!.stringValue.characters.count > 0 else
		{
			return false
		}
		
		let result = vinField!.stringValue.characters.count == 17
		
		if !result
		{
			showInvalidVINAlert()
		}
		
		return result
	}
	
	private func showInvalidVINAlert()
	{
		let alert = NSAlert()
		alert.messageText = "Whoops"
		alert.informativeText = "You must enter a valid 17 digit vin, preferably of a Porsche."
		alert.addButton(withTitle: "My Bad, I'll try harder this time.")
		
		alert.beginSheetModal(for: window!, completionHandler: nil)
	}
	
	// MARK: - Actions
	
	@IBAction private func goButtonClicked(_ sender: NSButton)
	{
		loadOptions()
	}
	
	@IBAction private func returnKeyPressed(_ sender: NSTextField)
	{
		loadOptions()
	}
	
}
