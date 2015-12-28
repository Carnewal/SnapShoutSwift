import UIKit
import AVFoundation
import CoreLocation


class AddShoutViewController: UITableViewController, UIImagePickerControllerDelegate, CLLocationManagerDelegate,UINavigationControllerDelegate
{
    //http://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift
    //http://www.techotopia.com/index.php/A_Swift_Example_iOS_8_Location_Application
    
    //Alamofire
    //SwiftyJSON
    //Purelayout
    

    @IBOutlet weak var tableV : UITableView!
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    
    
    @IBOutlet weak var snapView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var libraryBtn: UIButton!
    var imagePicker = UIImagePickerController!()
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var latestLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableV.allowsSelection = false;
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        sendBtn.enabled = false
    }

    

    @IBAction func addShout(sender: UIBarButtonItem) {
       
        
        sendBtn.enabled = false
        
        //self.navigationController!.popViewControllerAnimated(true)
        
        let alert = UIAlertController(title: "Alert", message: "Message: " + String(latestLocation.coordinate.latitude) + ", "  + String(latestLocation.coordinate.longitude), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func takeAPhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        //imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takeFromLibrary(sender: UIButton) {
        
        
        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        //imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        sendBtn.enabled = true
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        snapView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        latestLocation = locations[locations.count - 1]
    }
    
    
    
}