import UIKit

class CommentViewController: UITableViewController
{

    
    var currentTask: NSURLSessionTask?
    
    var shout: Shout!
    
    @IBOutlet weak var tfComment: UITextField!
    @IBOutlet weak var btnComment: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Comments for post.. in titel - te lang..
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shout.comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let comment = shout.comments[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        cell.textLabel!.text = comment
        return cell
    }

    @IBAction func sendCommentPressed(sender: UIBarButtonItem) {
        
        
        sender.enabled=false
        
        
        let commentText = tfComment.text!
        
        let params : String = "id=" + shout.id + "&" + "comment=" + commentText
        
        currentTask?.cancel()
        currentTask = Service.sharedService.createCommentTask(params,  completionHandler: {
            [unowned self] result in switch result {
            case .Success(let comment):
                self.shout.comments += [comment]
                self.tableView.reloadData()
                self.tfComment.text = ""
                
            case .Failure(let error):
                self.shout.comments += ["error"]
                self.tableView.reloadData()
            }
            
            sender.enabled = true
        })
        currentTask!.resume()
        
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
    
    
    
    deinit {
        print("Deinit")
        currentTask?.cancel()
    }
    
    
    
}