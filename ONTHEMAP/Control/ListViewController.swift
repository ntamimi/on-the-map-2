

import UIKit

class ListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBAction func logout(_ sender: Any) {
ExternalMethods.logout(currentController: self)    }
    var Studentlocations = [StudentInformation]()
    @IBOutlet weak var Table: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.Table.dataSource = self;
        self.Table.delegate = self;
        self.Table.rowHeight = 80.0

        getLocations()
    }
    
    @IBAction func reloud(_ sender: Any) {
        getLocations()
    }
    func getLocations(){

        UdacityURLS.getLocations(completion: {(success, data) in
            if success {
                self.Studentlocations = data!.StudentLocations
                DispatchQueue.main.async { self.Table.reloadData() }
            }
            else {
                DispatchQueue.main.async {
                   ExternalMethods.ErrorAlert(title: "Locations Failed" ,message: "ERROR", currentController: self) }
            }
        })

    }
  




    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Studentlocations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Table.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let user = self.Studentlocations[(indexPath as NSIndexPath).row]
        cell.username.text = user.firstName+" "+user.lastName
        cell.link.text = user.mediaURL
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = tableView.cellForRow(at: indexPath) as! TableViewCell
        if let toOpen = selectedRow.link.text,
            let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            DispatchQueue.main.async {
                ExternalMethods.ErrorAlert(title: "URL Failed" ,message: "ERROR", currentController: self) }
        }
    }




}
