//
//  PasswordDialog.swift
//  PasswordKeeper
//
//  Created by Tyler Rockwood on 3/6/16.
//  Copyright © 2016 Rose-Hulman. All rights reserved.
//

import UIKit
import Material

class PasswordDialog: UIView {

    static let height: CGFloat = 275.0
    
    @IBOutlet weak var serviceTextField: TextField!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setPassword(pw : Password) {
        serviceTextField.text = pw.service
        usernameTextField.text = pw.username
        passwordTextField.text = pw.password
    }
    
    func getPassword() -> Password {
        return Password(service: serviceTextField.text!,
                        username: usernameTextField.text,
                        password: passwordTextField.text!)
    }
    
    func prepareView() {
        var promptNames = ["Service Name", "Username", "Password"]
        for textField in [serviceTextField, usernameTextField, passwordTextField] {
            textField.placeholder = promptNames.removeAtIndex(0)
            
            textField.placeholderColor = MaterialColor.grey.base
            textField.font = RobotoFont.regularWithSize(20)
            textField.textColor = MaterialColor.black
        
            textField.font = RobotoFont.mediumWithSize(12)
            textField.textColor = MaterialColor.grey.base
//            textField.titleLabelActiveColor = MaterialColor.blue.accent3

            let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.AlwaysTemplate)

            textField.clearIconButton?.pulseColor = MaterialColor.grey.base
//            clearButton.pulseScale = false
            textField.clearIconButton?.tintColor = MaterialColor.grey.base
            textField.clearIconButton?.setImage(image, forState: .Normal)
            textField.clearIconButton?.setImage(image, forState: .Highlighted)

        }
    }
    
    class func instanceFromNib(owner : UIViewController) -> PasswordDialog {
        let dialog = NSBundle.mainBundle().loadNibNamed("PasswordDialog", owner: owner, options: nil)[0] as! PasswordDialog
        dialog.prepareView()
        return dialog
    }

}
