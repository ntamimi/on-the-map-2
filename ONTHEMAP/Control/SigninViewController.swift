

import UIKit

class Signin: UIViewController {


    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBAction func singinButton(_ sender: Any) {

    UdacityURLS.startSession(username: username.text ?? "", password: password.text ?? "") { (success, error , sessionId,accountKey) in
        
        guard error == nil else {
            DispatchQueue.main.async {
                ExternalMethods.ErrorAlert(title: "Login Failed", message: error!.localizedDescription , currentController: self)
            }
            return
        }
        
        if error != nil || !success{
            DispatchQueue.main.async {

                ExternalMethods.ErrorAlert(title: "Login Failed" ,message: "usernmame or password incorrect" , currentController: self)
            }
        }
        else if !success {DispatchQueue.main.async {

            ExternalMethods.ErrorAlert(title: "Login Failed" ,message: "no internter connection " , currentController: self)
            }}

        else if success  {
 DispatchQueue.main.async {
    self.performSegue(withIdentifier: "login", sender: self) }
}

        }
}

    @IBAction func signupButton(_ sender: Any) {
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup.") else { return }
        UIApplication.shared.open(url)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

