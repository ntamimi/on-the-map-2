

import Foundation
import CoreLocation

class UdacityURLS {


    static var sesssionID:String?
    static var accountKey:String?


   class func startSession(username: String, password: String, completion: @escaping(Bool, Error?,_ accountKey: Any?, _ sessionId: Any?) -> Void) {

    var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    // encoding a JSON body from a string, can also use a Codable struct
    request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
        guard error == nil else {
            completion(false, error, nil, nil)
            return
        }
print(" my respnse \(response)")
        if let httpResponse = response as? HTTPURLResponse{
            if httpResponse.statusCode != 200 {
                print(" respnse not 200 ")
                completion(false, error,nil, nil)
                return
            }
        }


        guard let data = data else {
            completion(false, error,nil, nil)
            return
        }

        let range = 5..<data.count
        let newData = data.subdata(in: range)

        let parsedData: [String : AnyObject]!
        do {
            parsedData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String : AnyObject]
        } catch {
            completion(false, error,nil,nil)
            return
        }

         let sessionDictionary = parsedData["session"] as? [String : AnyObject]
        let sessionId = sessionDictionary!["id"] as? String
         let accountDictionary = parsedData["account"] as? [String : AnyObject]
        let accountKey = accountDictionary?["key"] as? String
        self.sesssionID = sessionId
        self.accountKey = accountKey


        completion(true, error , sesssionID , accountKey)
    }
    task.resume()


    }


    class func getLocations(completion: @escaping (Bool, Locations?) -> Void) {
        var StudentLocations: [StudentInformation] = []

        var request = URLRequest(url: URL(string:"https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in


        guard let data = data else {
            DispatchQueue.main.async {
                completion(false, nil)
            }
            return
        }
        print(String(data: data, encoding: .utf8)!)

        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let dictionary = json as? [String:Any],
            let results = dictionary["results"] as? [Any] {

for result in results {
                let data = try! JSONSerialization.data(withJSONObject: result)
                do {
                let User = try JSONDecoder().decode(StudentInformation.self, from: data)
                StudentLocations.append(User)
                print(result)
                } catch {
                    print("opps ERROR")
                }
            }
        }

        completion(true, Locations(StudentLocations: StudentLocations))

    }
    task.resume()
}

   class func getStudentInformation(completion: @escaping (_ firstName: Any?, _ lastName: Any?,_ success: Bool, _ error: String?) -> Void){
    let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(self.accountKey!))")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            // Parse the JSON data into a dictionary
            let parsedData: [String : AnyObject]!
            do {
                parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String : AnyObject]
            } catch {
                completion(nil, nil, false, "error!")
                return
            }
        let firstName = parsedData["first_name"] as? String
        let lastName = parsedData["last_name"] as? String
            completion(firstName, lastName, true, nil)

        }
        task.resume()
    }


    class func postStudentLocation(firstName: String, lastName: String, locationName: String, link: String, coordinate:CLLocationCoordinate2D, completion: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("unique key \(self.accountKey!)")
        request.httpBody = "{\"uniqueKey\": \"\(self.accountKey!)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(locationName)\", \"mediaURL\": \"\(link)\",\"latitude\": \(coordinate.latitude), \"longitude\": \(coordinate.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let parsedResult: AnyObject!

            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject?
            } catch {
                completion(nil, false, "ERRRRRROR!!!!")
                return
            }
            print(String(data: data!, encoding: .utf8)!)

            DispatchQueue.main.async {
                completion((parsedResult as! [String : AnyObject]),true, nil)
            }
        }
        task.resume()
    }

    class func endSession(completion: @escaping(Bool, Error?) -> Void) {

        // Create Request
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        // Create dataTask
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            // No error, logout successful
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            self.sesssionID = ""
            self.accountKey = ""
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
        task.resume()
    }


}
