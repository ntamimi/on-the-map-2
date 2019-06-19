


import UIKit
import MapKit


class MapViewController: UIViewController , MKMapViewDelegate {
    @IBAction func logout(_ sender: Any) {
    ExternalMethods.logout(currentController: self)

    }
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate=self
 getLocations()
        // Do any additional setup after loading the view.
    }

    @IBAction func reloud(_ sender: Any) {
        print("load")
        getLocations()
    }

    func getLocations(){

        UdacityURLS.getLocations(completion: {(success, data) in
        if success {

            let locations = data?.StudentLocations

            var annotations = [MKPointAnnotation]()

            for location in locations! {
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(location.firstName) \(location.lastName)"
                annotation.subtitle = location.mediaURL
                annotations.append(annotation)
            }

            self.map.addAnnotations(annotations)
            }
        else {
            DispatchQueue.main.async {
                ExternalMethods.ErrorAlert(title: "Locations Failed" ,message: "ERROR" , currentController: self) }
            }
        })

    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

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

            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else{
                DispatchQueue.main.async {
                   ExternalMethods.ErrorAlert(title: "Locations Failed" ,message: "ERROR", currentController: self) }            }
} }

    

}
