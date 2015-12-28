import UIKit
import MapKit



class ShoutViewController: UITableViewController
{
    
    @IBOutlet weak var imageURL : UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var messageTextView: UITextView!
    
    var shout: Shout!
    
    override func viewDidLoad() {
        title = "SnapShout"
        
       messageTextView.text = shout.message
        
        
        //imageview
        
        let path = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: path)!
        if let urlShoutImg = NSURL(string: (string: properties["baseUrl"] as! String) + "/shout/" + shout.id + "/img") {
            imageURL.contentMode = .ScaleAspectFit
            downloadImage(urlShoutImg)
        }

        
        
        
        //map
        
        let center = CLLocationCoordinate2D(latitude: shout.location.latitude, longitude: shout.location.longitude)
        let visibleRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.region = visibleRegion
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = shout.author
        annotation.subtitle = " (" + shout.date + ") "
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        
        
    }
    
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.imageURL.image = UIImage(data: data)
            }
        }
    }
    
    
    
    /*
    By using traitCollectionDidChange instead of viewDidLoad, we also handles the case of an iPhone Plus rotating from portrait (collapsed)
    to landscape (expanded).
    */
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        if !splitViewController!.collapsed {
            navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem()
        }
    }
    
    
    
}