//
//  BookingViewController.swift
//  Felician_Ishark_cobsccomp192p049
//
//  Created by Felician Ishark on 2021-11-17.
//

import UIKit
import Firebase
import FirebaseDatabase

class BookingViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var txtRegNo: UITextField!
    @IBOutlet weak var txtVehiNo: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    public var db: Firestore?
    static var mySlotID = ""
    static var BtnTypeProperty = ""
    
    var SlotID  = [String]()
    var SlotName = [String]()
    var SlotStatus = [String]()
    var VehicalNo = [String]()
    
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.db = Firestore .firestore()
        tableView.delegate = self
        tableView.dataSource = self
        self.db = Firestore .firestore()
        
        self.db?.collection("Slots").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.SlotID.append(document.get("SlotID") as! String)
                    self.SlotName.append(document.get("SlotName") as! String)
                    self.SlotStatus.append(document.get("SlotStatus") as! String)
                    //self.VehicalNo.append(document.get("VehicalNo") as! String)
                    self.tableView.reloadData()
                }
            }
        }
        getRegVehiNo()
        // Do any additional setup after loading the view.
    }
    
    
    func getRegVehiNo() -> Void {
        let userID = Auth.auth().currentUser?.uid
        let docRef = self.db?.collection("User").document(userID!)
        docRef!.getDocument(source: .cache) { (document, error) in
          if let document = document {
           let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            self.txtVehiNo.text = String(document.get("VehicalNo") as! String)
            self.txtRegNo.text = String(document.get("RegistrationNo") as! String)
          } else {
            print("Document does not exist in cache")
          }
        }
    }
    
    // number of rows in table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SlotName.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // create a cell for each table view row  UITableViewCell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyBookingCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyBookingCell
        
        cell.SlotName.text = self.SlotName[indexPath.row]
        cell.SlotStatus.text = self.SlotStatus[indexPath.row]
        //cell.VehicalNo.text = self.VehicalNo[indexPath.row]
        cell.btnReserve.tag = Int(self.SlotID[indexPath.row])! ;
        cell.btnReserve.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        cell.btnBook.tag = Int(self.SlotID[indexPath.row])!;
        cell.btnBook.addTarget(self, action: #selector(buttonTapped2), for: .touchUpInside)
        
        cell.btnCancel.tag = Int(self.SlotID[indexPath.row])!;
        cell.btnCancel.addTarget(self, action: #selector(btCancelTapped), for: .touchUpInside)
        
        if(self.SlotStatus[indexPath.row] == "A")
               {
                   cell.btnReserve.isHidden = false
                   cell.btnBook.isHidden = false
                   cell.btnCancel.isHidden = true
               }
        else if(self.SlotStatus[indexPath.row] == "R")
              {
                 // cell.btnBook.isHidden = true
                   cell.btnReserve.isHidden = true
                   cell.btnBook.isHidden = false
                   cell.btnCancel.isHidden = true
              }
       else if(self.SlotStatus[indexPath.row] == "B")
              {
                  //cell.btnBook.isHidden = true //btnBook==btnReserve
                   cell.btnReserve.isHidden = true
                   cell.btnBook.isHidden = true
                   cell.btnCancel.isHidden = false
              }
        
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
    
    @objc func buttonTapped(_sender: UIButton)
      {
          let alrt = UIAlertController(title: "test", message: "test", preferredStyle: .alert)
          alrt.addAction(UIAlertAction(title: "ok",style: .cancel,handler: nil))
          self.present(alrt, animated: true)
          BookingViewController.mySlotID = String(_sender.tag);
          BookingViewController.BtnTypeProperty = "Booking";
      }
      @objc func buttonTapped2(_sender: UIButton)
      {
          BookingViewController.mySlotID = String(_sender.tag);
          let alrt = UIAlertController(title: "test2", message: "test2", preferredStyle: .alert)

          alrt.addAction(UIAlertAction(title: "ok",style: .cancel,handler: nil))
          self.present(alrt, animated: true)
      }
    
    @objc func btCancelTapped(_sender: UIButton)
      {
          let alrt = UIAlertController(title: "test2", message: "test2", preferredStyle: .alert)
          alrt.addAction(UIAlertAction(title: "ok",style: .cancel,handler: nil))
          self.present(alrt, animated: true)
          BookingViewController.mySlotID = String(_sender.tag);
          BookingViewController.BtnTypeProperty = "Cancel";
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
}
