
import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var presentImageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // List that contains NSData downloaded from Get request
    var imagesSaved: [NSData]!
    let emptyImage = NSData()
    
    // List that contains URLs
    var images: [String]!
    
    // number of image that is displayed
    var presentImage = 0
    
    /// Method that displays next image
    @IBAction func right(sender: AnyObject) {
        // Change presentImage number
        if self.presentImage < 3 {
            self.presentImage += 1
        }
        else {
            self.presentImage = 0
        }
        
        // Display next image
        if let image = UIImage(data:self.imagesSaved[self.presentImage]) {
                self.image.image = image
                self.changePresentImageLabel()
        }
        else {
            // An alert is displayed if an error ocurred
            print("Error")
            let alert = UIAlertController(title: "UPS", message: "The image couldn´t be loaded", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /// Method that shows previous image
    @IBAction func left(sender: AnyObject) {
        // Change presentImage number
        if self.presentImage > 0 {
            self.presentImage -= 1
        }
        else {
            self.presentImage = 3
        }
        
        // Display next image
        if let image = UIImage(data:self.imagesSaved[self.presentImage]) {
            self.image.image = image
            self.changePresentImageLabel()
        }
        else {
            // An alert is displayed if an error ocurred
            print("Error")
            let alert = UIAlertController(title: "UPS", message: "The image could not be loaded", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /// Method that changes presentImageLabel.text according to presentImage number
    func changePresentImageLabel() {
        switch self.presentImage {
        case 0:
            self.presentImageLabel.text = " 1 of 4"
        case 1:
            self.presentImageLabel.text = " 2 of 4"
        case 2:
            self.presentImageLabel.text = " 3 of 4"
        case 3:
            self.presentImageLabel.text = " 4 of 4"
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.images = []
        self.imagesSaved = [self.emptyImage, self.emptyImage, self.emptyImage, emptyImage]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Method invoked when the button "Search" is pressed
    @IBAction func get(sender: AnyObject) {
        // Activity indicator starts
        self.activityIndicator.startAnimating()
        
        // Reset presentImage
        self.presentImage = 0
        
        // Remove old urls
        self.images = []
        
        // Remove old NSdata
        self.imagesSaved = [self.emptyImage, self.emptyImage, self.emptyImage, emptyImage]
        
        // Get text from UITextField
        let search = self.text.text
        
        // Url is instanciated
        let url = NSURL(string : "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+search!)
        
        // Request is instanciated
        let request = NSMutableURLRequest(URL : url!)
        
        // Choose GET request
        request.HTTPMethod = "GET"
        
        // Execute request
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            
            // An Alert is displayed if an error occurred
            if error != nil || search == "" {
                let alert = UIAlertController(title: "UPS", message: "An error occurred", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
            else {
                // Get Json
                let jsonSwift: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                // Parsing Json into dictionary
                if let jsonDiccionario = jsonSwift as? Dictionary<String,NSObject> {
                    let responseData = jsonDiccionario["responseData"] as! Dictionary<String,NSObject>
                    let results = responseData["results"] as! NSArray
                    for element in results {
                        if let imageJson = element as? Dictionary<String,NSObject> {
                            // Get Url from Dictionary
                            let urlImage = imageJson["url"] as! String
                            // Save URL
                            self.images.append(urlImage)
                        }
                    }
                    // Starts downloading the images
                    self.download()
                }
            }
        }
        // Reset UITextField
        self.text.text = ""
    }
    
    /// Method invoked to download the images
    func download() {
        if images.count > 0 {
        for index in 0...3 {
         print(index)

             if let url = NSURL(string: self.images[index]) {
               if let data = NSData(contentsOfURL: url) {
               // if index is 0, download and display the image
                  if index == 0 {
                     self.imagesSaved[index] = data
                     self.image.image = UIImage(data:self.imagesSaved[index])
                  }
                  else {
                     // if index is not 0, download the image
                     self.imagesSaved[index] = data
                  }
               }
            }
            
        
            }
        // Display the number of the image
        self.presentImageLabel.text = " 1 of 4"
        
        // Stop animating the activity indicator
        self.activityIndicator.stopAnimating()
        }
    }
    
    // Method that dismisses keyboard by touching the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
         self.view.endEditing(true)
    }
    
}
