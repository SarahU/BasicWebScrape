//
//  ShareViewController.swift
//  ShareToMeTarget
//
//  Created by Sarah Usher on 06/11/2017.
//  Copyright © 2017 Sarah Usher. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    private var url: NSURL?
    private var pageTitle: String = "no title"
    private var priceString: String = "no price string found"

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func viewDidLoad() {
        getWebpageData()
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        print("in didSelectPost, url is: \(self.url?.absoluteString ?? "url not set")")
        print("in didSelectPost, title is: \(self.pageTitle)")
        print("in didSelectPost, priceString is: \(self.priceString)")
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        print("in method configurationItems")
        
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.

        
        return []
    }
    
    
    private func getWebpageData() {
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let urlString = results["URL"] as? String,
                        let titleString = results["TITLE"] as? String,
                        let priceText = results["PRICETEXT"] as? String,
                        let url = NSURL(string: urlString) {
                        self.url = url
                        self.pageTitle = titleString
                        self.priceString = priceText
                    }
                }
            })
        } else {
            print("error")
        }
    }

}
