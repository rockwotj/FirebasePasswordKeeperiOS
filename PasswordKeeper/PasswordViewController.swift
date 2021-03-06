//
//  PasswordViewController.swift
//  PasswordKeeper
//
//  Created by Tyler Rockwood on 3/5/16.
//  Copyright © 2016 Rose-Hulman. All rights reserved.
//

import UIKit
import FoldingCell
import Material
import Firebase

class PasswordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let kCloseCellHeight: CGFloat = 85
  let kOpenCellHeight: CGFloat = 240
  var cellHeights = [CGFloat]()
  var passwords = [Password]()

  var passwordRef :FIRDatabaseReference!

  //  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
  //    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  //  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var fab: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    let firebaseRef = FIRDatabase.database().reference()

    passwordRef = firebaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)")

    passwordRef.observeEventType(.ChildAdded) { snapshot in self.passwordAdded(snapshot) }
    passwordRef.observeEventType(.ChildChanged) { snapshot in self.passwordChanged(snapshot) }
    passwordRef.observeEventType(.ChildRemoved) { snapshot in self.passwordRemoved(snapshot) }

    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.setUpFab()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }


  func setUpFab() {
    let img: UIImage? = UIImage(named: "ic_add_white")
    fab.backgroundColor = MaterialColor.indigo.base
    fab.tintColor = MaterialColor.white
    fab.setImage(img, forState: .Normal)
    fab.setImage(img, forState: .Highlighted)
  }

  // MARK: - Firebase Methods

  func passwordAdded(data : FIRDataSnapshot) {
    let password = Password(json: data.value as! [String: AnyObject])
    password.key = data.key
    passwords.insert(password, atIndex: 0)
    cellHeights.insert(kCloseCellHeight, atIndex: 0)
    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
  }

  func passwordRemoved(data : FIRDataSnapshot) {
    for (i, password) in passwords.enumerate() {
      if password.key == data.key {
        passwords.removeAtIndex(i)
        cellHeights.removeAtIndex(i)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .Automatic)
        break
      }
    }
  }

  func passwordChanged(data : FIRDataSnapshot) {
    for (i, password) in passwords.enumerate() {
      if password.key == data.key {
        password.service = data.value!.objectForKey("service") as! String
        password.password = data.value!.objectForKey("password") as! String
        password.username = data.value!.objectForKey("username") as? String
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: i, inSection: 0)], withRowAnimation: .Automatic)
        break
      }
    }
  }

  // MARK: - Button Click Handlers

  func onEdit(pw : Password) {
    let alertController = UIAlertController(title: "Edit password", message: "", preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.text = pw.service
      textField.placeholder = "Service"
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.text = pw.username
      textField.placeholder = "Username"
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.text = pw.password
      textField.placeholder = "Password"
      textField.secureTextEntry = true
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    let defaultAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default) { (action) -> Void in
      let serviceTextField = alertController.textFields![0] as UITextField
      let usernameTextField = alertController.textFields![1] as UITextField
      let passwordTextField = alertController.textFields![2] as UITextField

      let pwRef = self.passwordRef.child(pw.key)
      pwRef.setValue([
        "service": serviceTextField.text as String!,
        "username": usernameTextField.text as String!,
        "password": passwordTextField.text as String!,
        ])
    }
    alertController.addAction(cancelAction)
    alertController.addAction(defaultAction)
    presentViewController(alertController, animated: true, completion: nil)
  }

  func onDelete(pw : Password) {
    let alertController = UIAlertController(title: "Delete password", message: "Are you sure?", preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive) { (action) -> Void in
      let pwRef = self.passwordRef.child(pw.key)
      pwRef.removeValue()
    }
    alertController.addAction(cancelAction)
    alertController.addAction(deleteAction)
    presentViewController(alertController, animated: true, completion: nil)

  }

  @IBAction func addPassword(sender: AnyObject) {
    let alertController = UIAlertController(title: "Add password", message: "", preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Service"
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Username"
    }
    alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
      textField.placeholder = "Password"
      textField.secureTextEntry = true
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
    let defaultAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default) { (action) -> Void in
      let serviceTextField = alertController.textFields![0] as UITextField
      let usernameTextField = alertController.textFields![1] as UITextField
      let passwordTextField = alertController.textFields![2] as UITextField

      let pwRef = self.passwordRef.childByAutoId()
      pwRef.setValue([
        "service": serviceTextField.text as String!,
        "password": usernameTextField.text as String!,
        "username": passwordTextField.text as String!
        ])
    }
    alertController.addAction(cancelAction)
    alertController.addAction(defaultAction)
    presentViewController(alertController, animated: true, completion: nil)
  }

  // MARK: - Table View Methods

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return passwords.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PasswordCell", forIndexPath: indexPath)
    if let passwordCell = cell as? PasswordCell {
      passwordCell.bindPassword(passwords[indexPath.row])
      passwordCell.editPasswordHandler = onEdit
      passwordCell.deletePasswordHandler = onDelete
    }
    return cell
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeights[indexPath.row]
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell

    var duration = 0.0
    if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
      cellHeights[indexPath.row] = kOpenCellHeight
      cell.selectedAnimation(true, animated: true, completion: nil)
      duration = 0.5
    } else {// close cell
      cellHeights[indexPath.row] = kCloseCellHeight
      cell.selectedAnimation(false, animated: true, completion: nil)
      duration = 1.1
    }

    UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
      tableView.beginUpdates()
      tableView.endUpdates()
      }, completion: nil)
  }

  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if cell is FoldingCell {
      let foldingCell = cell as! FoldingCell

      if cellHeights[indexPath.row] == kCloseCellHeight {
        foldingCell.selectedAnimation(false, animated: false, completion:nil)
      } else {
        foldingCell.selectedAnimation(true, animated: false, completion: nil)
      }
    }
  }
}
