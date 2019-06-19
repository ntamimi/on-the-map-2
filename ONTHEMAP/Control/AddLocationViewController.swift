

import UIKit
import CoreLocation


class AddLocationViewController: UIViewController {
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var location: UITextField!
    var coordinate = CLLocationCoordinate2D()
    var locationName = ""

    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBAction func findlocation(_ sender: Any) {
self.activity.isHidden = false
self.activity.startAnimating()
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(location.text!) { (placemarks, error) in

            if error != nil {

                    DispatchQueue.main.async {
                        ExternalMethods.ErrorAlert(title: "Location Failed" ,message: "ERROR", currentController: self) }

            } else {
                let placemark = placemarks?.first

                if let placemark = placemark {
                    self.coordinate = (placemark.location?.coordinate)!
                    self.locationName = placemark.name!
                    self.activity.stopAnimating()
self.activity.isHidden = true
                    self.performSegue(withIdentifier: "sendData", sender: self)

                } else {
                    DispatchQueue.main.async {
                        ExternalMethods.ErrorAlert(title: "Location Failed" ,message: "ERROR", currentController: self) }
                }
            }
        }


    }

    override func viewDidLoad() {
        super.viewDidLoad()
self.activity.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendData"{
            let destVC : NewLocationViewController = segue.destination as! NewLocationViewController
            destVC.coordinate = self.coordinate
            destVC.locationName = self.locationName
            destVC.link = self.link.text!
        }
    }


}
