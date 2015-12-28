import Foundation

class Shout
{
    let id: String
    let author: String
    let message: String
    let date: String
    let location: Location
    
    init(id: String, author: String, message: String, date: String, location: Location) {
        self.id = id
        self.author = author
        self.message = message
        self.date = date
        self.location = location
    }
    
}

//  extension Shout: CustomStringConvertible { }

extension Shout
{
    convenience init(json: NSDictionary) throws {
        guard let id = json["_id"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "_id")
        }
        guard let author = json["author"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "author")
        }
        guard let message = json["message"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "message")
        }
        guard let date = json["date"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "date")
        }
        guard let loc = json["loc"] as? [Double] else {
            throw Service.Error.MissingJsonProperty(name: "latitude")
        }
        
        self.init(id: id, author: author, message: message, date: date, location: Location(latitude: loc[0], longitude: loc[1]))
        
        
    }
}