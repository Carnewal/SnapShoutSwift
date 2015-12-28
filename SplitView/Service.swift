import Foundation

class Service
{
    enum Error: ErrorType
    {
        case InvalidJsonData(message: String?)
        case MissingJsonProperty(name: String)
        case MissingResponseData
        case NetworkError(message: String?)
        case UnexpectedStatusCode(code: Int)
    }
    
    static let sharedService = Service()
    
    private let urlShouts: NSURL
    private let urlPostShout: NSURL
    
    private let session: NSURLSession
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: path)!
        urlShouts = NSURL(string: (string: properties["baseUrl"] as! String) + "/shouts")!
        urlShouts = NSURL(string: (string: properties["baseUrl"] as! String) + "/shout")!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }
    
    func createPostTask() -> NSURLSessionTask {
        
    
    }
    
    
    func createFetchTask(completionHandler: Result<[Shout]> -> Void) -> NSURLSessionTask {
        return session.dataTaskWithURL(urlShouts) {
            data, response, error in
            
            let completionHandler: Result<[Shout]> -> Void = {
                result in
                dispatch_async(dispatch_get_main_queue()) {
                    completionHandler(result)
                }
            }
            
            guard let response = response as? NSHTTPURLResponse else {
                completionHandler(.Failure(.NetworkError(message: error?.description)))
                return
            }
            guard response.statusCode == 200 else {
                completionHandler(.Failure(.UnexpectedStatusCode(code: response.statusCode)))
                return
            }
            guard let data = data else {
                completionHandler(.Failure(.MissingResponseData))
                return
            }
            
            do {
                guard let jsonShouts = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray else {
                    completionHandler(.Failure(.InvalidJsonData(message: "Data does not contain a root object.")))
                    return
                }
              
                let shouts = try jsonShouts.map { try Shout(json: $0 as! NSDictionary) }
                completionHandler(.Success(shouts))
            } catch let error as NSError {
                completionHandler(.Failure(.InvalidJsonData(message: error.description)))
            } catch let error as Error {
                completionHandler(.Failure(error))
            }
        }
    }
}