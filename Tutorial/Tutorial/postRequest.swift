//
//  postRequest.swift
//  Tutorial
//
//  Created by David Galemiri on 21-09-15.
//  Copyright © 2015 mecolab. All rights reserved.
//


import UIKit

class postRequest: ViewController {
    // Outlets and variables
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var textView: UITextView!
    var saveStatus: String!
    var saveResponse: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Method that is launched when the button "Post Request" is pressed
    @IBAction func post(sender: AnyObject) {
        // The request is instanciated
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.codepunker.com/tools/http-requests")!)
        
        // Choose POST request
        request.HTTPMethod = "POST"
        
        // Body
        let postString = "extra=whoAreYou&execute=demoRequests"
        
        // Convert body String into NSData
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Execute request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            // An UIAlert is launched if an error occurred
            if error != nil {
                print(error, terminator: "")
                let alert = UIAlertController(title: "UPS", message: "An error occurred", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                // Get Json
                let json : AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                
                // Parsing Json into dictionary
                if let jsonDictionary = json as? Dictionary<String,NSObject> {
                    let jsonStatus = jsonDictionary["type"] as! String
                    let jsonResponse = jsonDictionary["response"] as! String
                    self.saveStatus =  jsonStatus
                    self.saveResponse = jsonResponse
                    self.textView.text = self.saveResponse
                    self.status.text = self.saveStatus
                }
                else {
                    // An UIAlert is launched if an error occurred
                    let alert = UIAlertController(title: "UPS", message: "An error occurred", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
