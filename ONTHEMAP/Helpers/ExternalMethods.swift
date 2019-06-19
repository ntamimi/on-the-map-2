//
//  SharedMethods.swift
//  ONTHEMAP
//


import Foundation
import UIKit

class ExternalMethods {

    class func logout(currentController: UIViewController) {

        UdacityURLS.endSession { (success, error) in

            if success {
                currentController.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                print(error)
            }
        }

    }

    class func ErrorAlert(title: String, message: String , currentController: UIViewController) {

        var oper = OperationQueue()

        let alertMsg = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertMsg.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
       oper.addOperation { OperationQueue.main.addOperation({
                currentController.present(alertMsg, animated: true, completion: nil)
            })}

    }
}
