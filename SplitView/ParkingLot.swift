import Foundation

class ParkingLot
{
    let description: String
    let location: Location
    let capacity: Int
    var availableCapacity: Int
    
    init(description: String, location: Location, capacity: Int, availableCapacity: Int) {
        self.description = description
        self.location = location
        self.capacity = capacity
        self.availableCapacity = availableCapacity
    }
}

extension ParkingLot: CustomStringConvertible { }

extension ParkingLot
{
    convenience init(json: NSDictionary) throws {
        guard let description = json["description"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "description")
        }
        guard let latitude = json["latitude"] as? Double else {
            throw Service.Error.MissingJsonProperty(name: "latitude")
        }
        guard let longitude = json["longitude"] as? Double else {
            throw Service.Error.MissingJsonProperty(name: "longitude")
        }
        guard let capacity = json["totalCapacity"] as? Int else {
            throw Service.Error.MissingJsonProperty(name: "totalCapacity")
        }
        guard let availableCapacity = json["availableCapacity"] else {
            throw Service.Error.MissingJsonProperty(name: "availableCapacity")
        }
        if let availableCapacity = availableCapacity as? Int {
            self.init(description: description, location: Location(latitude: latitude, longitude: longitude), capacity: capacity, availableCapacity: availableCapacity)
        } else {
            // Bug in back-end: availableCapacity is an empty string instead of 0.
            self.init(description: description, location: Location(latitude: latitude, longitude: longitude), capacity: capacity, availableCapacity: 0)
        }
    }
}