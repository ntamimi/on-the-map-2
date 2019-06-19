

import UIKit
import MapKit
import CoreLocation

class NewLocationViewController: UIViewController ,MKMapViewDelegate  {

    @IBAction func submitlocation(_ sender: Any) {
        UdacityURLS.getStudentInformation { (firstname, lastname, sucess, error) in
            if sucess {
                UdacityURLS.postStudentLocation(firstName: firstname as! String, lastName: lastname as! String, locationName: self.locationName, link: self.link, coordinate: self.coordinate, completion: { (arr, sucess, error) in
                    if sucess {

                    } else {
                        DispatchQueue.main.async {
                          ExternalMethods.ErrorAlert(title: "Add Failed" ,message: "Error", currentController: self) } }

                }) } else {
            DispatchQueue.main.async {
                ExternalMethods.ErrorAlert(title: "User Failed " ,message: "Error", currentController: self) }}
        }
    }
    
    @IBOutlet weak var map: MKMapView!
    var coordinate = CLLocationCoordinate2D()
    var locationName = ""
    var link = ""

    override func viewDidLoad() {
        super.viewDidLoad()
placePin()
        // Do any additional setup after loading the view.
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = map.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared

            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    private func placePin(){
        let coordinate = CLLocationCoordinate2D(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = locationName
        self.map.addAnnotation(annotation)
    }



}
