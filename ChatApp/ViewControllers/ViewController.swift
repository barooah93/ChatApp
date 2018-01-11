//
//  ViewController.swift
//  ChatApp
//
//  Created by Brandon Barooah on 1/10/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var chatTextField: UITextField!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var ref = FIRDatabaseReference.init()
    
    var userName : String?
    var chatList = [Chat]()
    
    var originalWindowFrame:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.ref = FIRDatabase.database().reference()
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTextField.delegate = self
        
        loginAnonymous()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        originalWindowFrame = self.view.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func loginAnonymous(){
        FIRAuth.auth()?.signInAnonymously(completion: { (user, err) in
            if let err = err {
                print("Could not sign in \(err.localizedDescription)")
            } else {
                print("User: \(user?.uid ?? "None")")
                self.loadChatRoom()
            }
        })
    }
    
    func loadChatRoom(){
        self.ref.child("chat").queryOrdered(byChild: "postDate").observe(.value) { (snapshot) in
            self.chatList.removeAll()
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if let chatData:[String:Any] = snap.value as? [String:Any] {
                        let username = chatData["name"] as? String
                        let message = chatData["text"] as? String
                        let date = chatData["postDate"] as? Double
                        
                        let nsDate = Date(timeIntervalSince1970: date!/1000)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy hh:mma"
                        dateFormatter.timeZone = NSTimeZone.local
                        
                        self.chatList.append(Chat(userName: username!, text: message!, datePosted: dateFormatter.string(from: nsDate)))
                    }
                }
                
            }
            self.chatTableView.reloadData()
            self.scrollTableToBottom()
        }
    }
    
    func scrollTableToBottom(){
        if(self.chatList.count > 0){
            let indexpath = IndexPath(row: self.chatList.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexpath, at: .bottom, animated: true)
        }
    }
    

    @IBAction func sendButtonPressed(_ sender: Any) {
        let dict = ["text": chatTextField.text!,
                    "name":userName ?? "Uknown",
                    "postDate":FIRServerValue.timestamp()] as Dictionary<String, Any>
        self.ref.child("chat").childByAutoId().setValue(dict)
    }
    
}

extension ViewController {
    
    // Keyboard notifications
    @objc func keyboardWillShow(_ notification:NSNotification){
        var info = notification.userInfo;
        if let keyboardSize = (info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            let bottomOfTextView = chatTextField.frame.origin.y + chatTextField.frame.size.height
            let keyboardHeight = keyboardSize.height
            let keyboardY = originalWindowFrame!.height - keyboardHeight;
            var newFrame = CGRect(x: (originalWindowFrame?.origin.x)!,
                                  y: (originalWindowFrame?.origin.y)!,
                                  width: (originalWindowFrame?.size.width)!,
                                  height: (originalWindowFrame?.size.height)!)
            let diff = bottomOfTextView - keyboardY + 5;
            if(diff > 0){
                newFrame.size.height -= diff;
                self.view.frame = newFrame
            }
        }
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        self.view.frame = self.originalWindowFrame!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        cell.setChat(chat: self.chatList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.chatTextField.resignFirstResponder()
        return false
    }
}



