import UIKit

class ShoutsViewController: UITableViewController, UISplitViewControllerDelegate
{
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var shouts: [Shout] = []
    var currentTask: NSURLSessionTask?
    
    override func viewDidLoad() {
        splitViewController!.delegate = self
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: activityIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: activityIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1, constant: 0)
        tableView.addSubview(activityIndicator)
        tableView.addConstraints([c1, c2])
        activityIndicator.startAnimating()
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        let c3 = NSLayoutConstraint(item: errorView, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        let c4 = NSLayoutConstraint(item: errorView, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1, constant: 0)
        let c5 = NSLayoutConstraint(item: errorView, attribute: .Width, relatedBy: .Equal, toItem: tableView, attribute: .Width, multiplier: 1, constant: -16)
        let c6 = NSLayoutConstraint(item: errorView, attribute: .Height, relatedBy: .Equal, toItem: tableView, attribute: .Height, multiplier: 1, constant: 0)
        tableView.addSubview(errorView)
        tableView.addConstraints([c3, c4, c5, c6])
        errorView.hidden = true

        currentTask = Service.sharedService.createFetchTask {
            [unowned self] result in switch result {
            case .Success(let shouts):
                self.shouts = shouts.sort { $0.date < $1.date }
                self.tableView.reloadData()
                self.errorView.hidden = true
            case .Failure(let error):
                self.errorLabel.text = "\(error)"
                self.errorView.hidden = false
            }
            activityIndicator.stopAnimating()
        }
        currentTask!.resume()
    }
    
    deinit {
        print("Deinit")
        currentTask?.cancel()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //return 1
        if(shouts.count > 0) {
            self.tableView.backgroundView = nil;
            return 1;
            
        } else {
            let messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = "Er zijn momenteel geen snaps in jouw buurt, swipe down om te refreshen of maak er zelf eentje!";
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignment.Center;
            self.tableView.backgroundView = messageLabel;
            return 0;
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let shout = shouts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("shoutCell", forIndexPath: indexPath)
        cell.textLabel!.text = shout.author
        return cell
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        currentTask?.cancel()
        currentTask = Service.sharedService.createFetchTask {
            [unowned self] result in switch result {
            case .Success(let shouts):
                self.shouts = shouts.sort { $0.date < $1.date }
                self.tableView.reloadData()
                self.errorView.hidden = true
            case .Failure(let error):
                self.errorLabel.text = "\(error)"
                self.errorView.hidden = false
            }
            sender.endRefreshing()
        }
        currentTask!.resume()
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let segueID = segue.identifier

        if(segueID == "addShout") {
            
            
            
        } else {
            
            let destController = (segue.destinationViewController as! UINavigationController).topViewController as! ShoutViewController
            
            let selectedShout = shouts[tableView.indexPathForSelectedRow!.row]
            
            destController.shout = selectedShout
        }

        

    }
}