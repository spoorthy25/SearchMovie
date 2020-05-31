//
//  AlertController.swift
//  MovieSearchApp
//
//  Created by Spoorthy Kancharla on 31/5/20.
//  Copyright © 2020 Spoorthy Kancharla. All rights reserved.
//

import Foundation
import UIKit

/**
 AlertController - handles all alerts used in the app
 Alert dialog and activity indicator
 */
class AlertController: UIViewController {

    /**
     showAlert - display alert dialog on the screen
     message - alert message text
     title - alert message title
     buttonText - button text to be displayed on alert dialog
     */
    class func showAlert(message:String,title: String,vc: ViewController,buttonText: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    /**
     showActivityIndicator - display the progress indicator
     */
    class func showActivityIndicator(view: UIView) -> UIActivityIndicatorView{
    
        let container: UIView = UIView()
        container.backgroundColor = .clear

        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = UIColor.red
        activityView.center = view.center

        container.addSubview(activityView)
        view.addSubview(container)
        
        return activityView
    }
    
    
}
