//
//  LoginViewController.swift
//  PasswordKeeper
//
//  Created by Tyler Rockwood on 3/6/16.
//  Copyright © 2016 Rose-Hulman. All rights reserved.
//

import UIKit
import Material
import Firebase
import Rosefire

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

  @IBOutlet weak var titleLabel: UILabel!

  @IBOutlet weak var emailTextField: TextField!
  @IBOutlet weak var passwordTextField: TextField!

  @IBOutlet weak var emailPasswordLoginButton: RaisedButton!
  @IBOutlet weak var rosefireLoginButton: RaisedButton!
  @IBOutlet weak var googleLoginButton: GIDSignInButton!

  // MARK: - Login Methods

  var loginClosure: FIRAuthResultCallback {
    get {
      //      let loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(view, message: "Logging In...")
      return { (user, err) in
        //        loadingDialog.hideDialog()
        if err == nil {
          self.appDelegate.handleLogin()
        } else {
          let alertController = UIAlertController(title: "Login failed", message: "", preferredStyle: .Alert)
          let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
          alertController.addAction(okAction)
          self.presentViewController(alertController, animated: true, completion: nil)
          print(err?.localizedDescription)
        }
      }
    }
  }

  @IBAction func emailPasswordLogin(sender: AnyObject) {
    FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!, completion: loginClosure)
  }

  @IBAction func rosefireLogin(sender: AnyObject) {
    Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
    Rosefire.sharedDelegate().signIn(ROSEFIRE_TOKEN) { (err, token) in
      if err == nil {
        FIRAuth.auth()?.signInWithCustomToken(token, completion: self.loginClosure)
      }
    }
  }

  @IBAction func googleLogin(sender: AnyObject) {
    self.dismissViewControllerAnimated(true) {
      GIDSignIn.sharedInstance().signIn()
    }
  }

  // Implement the required GIDSignInDelegate methods
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
              withError error: NSError!) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
    let authentication = user.authentication
    let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
    FIRAuth.auth()?.signInWithCredential(credential, completion: loginClosure)
  }

  // Implement the required GIDSignInDelegate methods
  // Unauth when disconnected from Google
  func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
              withError error: NSError!) {
    try! FIRAuth.auth()?.signOut()
  }

  // MARK: - View Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()

    // Setup delegates
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self

    // Attempt to sign in silently, this will succeed if
    // the user has recently been authenticated
    // GIDSignIn.sharedInstance().signInSilently()

  }

  func prepareView() {
    self.view.backgroundColor = MaterialColor.indigo.base

    titleLabel.font = RobotoFont.thinWithSize(36)

    googleLoginButton.style = .Wide

    var textField = emailTextField
    textField.placeholder = "Email"
    textField.placeholderColor = MaterialColor.grey.lighten4
    textField.font = RobotoFont.regularWithSize(20)
    textField.textColor = MaterialColor.white
    textField.backgroundColor = MaterialColor.clear

    textField.font = RobotoFont.mediumWithSize(12)
    textField.textColor = MaterialColor.white
    //    textField.textActiveColor = MaterialColor.white

    /*
     Used to display the error message, which is displayed when
     the user presses the 'return' key.
     */
    textField.detailLabel.text = "Email is incorrect."
    textField.detailLabel.font = RobotoFont.mediumWithSize(12)
    //    textField.detailLabel.activeColor = MaterialColor.red.accent3
    // textField.detailLabelAutoHideEnabled = false // Uncomment this line to have manual hiding.

    let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.AlwaysTemplate)

    textField.clearIconButton?.pulseColor = MaterialColor.grey.lighten4
    //            clearButton.pulseScale = false
    textField.clearIconButton?.tintColor = MaterialColor.grey.lighten4
    textField.clearIconButton?.setImage(image, forState: .Normal)
    textField.clearIconButton?.setImage(image, forState: .Highlighted)


    // Set up password field
    textField = passwordTextField
    textField.placeholder = "Password"
    textField.placeholderColor = MaterialColor.grey.lighten4
    textField.font = RobotoFont.regularWithSize(20)
    textField.textColor = MaterialColor.white
    textField.backgroundColor = MaterialColor.clear

    textField.font = RobotoFont.mediumWithSize(12)
    textField.textColor = MaterialColor.white
    //    textField.titleLabelActiveColor = MaterialColor.white

    textField.clearIconButton?.pulseColor = MaterialColor.grey.lighten4
    //            clearButton.pulseScale = false
    textField.clearIconButton?.tintColor = MaterialColor.grey.lighten4
    textField.clearIconButton?.setImage(image, forState: .Normal)
    textField.clearIconButton?.setImage(image, forState: .Highlighted)



    emailPasswordLoginButton.setTitle("Email/Password Login", forState: .Normal)
    emailPasswordLoginButton.titleLabel!.font = RobotoFont.mediumWithSize(18)
    emailPasswordLoginButton.backgroundColor = MaterialColor.indigo.darken2

    rosefireLoginButton.setTitle("Rosefire Login", forState: .Normal)
    rosefireLoginButton.titleLabel!.font = RobotoFont.mediumWithSize(18)
    rosefireLoginButton.backgroundColor = MaterialColor.indigo.darken2
  }
  
}
