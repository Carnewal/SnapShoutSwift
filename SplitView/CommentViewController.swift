import UIKit

class CommentViewController: UITableViewController
{

    var shout: Shout!
    
    @IBOutlet weak var tfComment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Commentsss"
        
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shout.comments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let comment = shout.comments[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("shoutCell", forIndexPath: indexPath)
        cell.textLabel!.text = comment
        return cell
    }

    @IBAction func sendCommentPressed(sender: UIBarButtonItem) {
        
        let commentText = tfComment.text!
        shout.comments += [commentText]
        
        self.tableView.reloadData()
        
        
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