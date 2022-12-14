//
//  EventDetails2.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/27.
//

import Foundation
//
//  EventDetails.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/27.
//

import Foundation
import UIKit
import SQLite3
import SQLite

class EventDetails2: UIViewController{
    
    let id_ = Expression<Int>("id")
    let title_ = Expression<String?>("title")
    let summary_ = Expression<String>("summary")
    let type_ = Expression<String>("type")
    let day = Expression<Int>("day")
    let month = Expression<Int>("month")
    let year = Expression<Int>("year")
    
    var id: Int!
    var dateDay: Int!
    var dateMonth: Int!
    var dateYear: Int!
    var eventTitle:String!
    var summary:String!
    var type:String!
    
    var backgroundImage: UIImageView!
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var TypeField: UITextField!
    @IBOutlet weak var SummaryField: UITextView!
    
    @IBOutlet weak var tlabel: UILabel!
    @IBOutlet weak var slabel: UILabel!
    @IBOutlet weak var tylabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DateLabel.text = Variable.shared.date
        let dateArr = Variable.shared.date.components(separatedBy: " ")
        let realDateArr = dateArr[1].components(separatedBy: "-")
        dateYear = Int(realDateArr[2])
        dateMonth = Int(realDateArr[0])
        dateDay = Int(realDateArr[1])
        
        TitleField.text = eventTitle
        SummaryField.text = summary
        TypeField.text = type
        
        self.backgroundImage = UIImageView(image: UIImage(named: "background4"))
        self.backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(self.backgroundImage, at: 0)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backgroundImage.frame = self.view.bounds
    }
    @IBAction func submitEvent(_ sender: Any) {
        
        let path = Bundle.main.path(forResource: "Final", ofType: "db")!
        let db = try! Connection(path, readonly: false)
        let events = Table("events")
        if(TitleField.text?.isEmpty == false){
            eventTitle = TitleField.text
        }
        else{
            eventTitle = "blank"}
        let e = events.filter(id_ == id)
        do {
            try db.run(e.update(title_ <- eventTitle))}
        catch{
            print("title update error")
        }
        if(SummaryField.text?.isEmpty == false){
            summary = SummaryField.text
        }
        else{
            summary = "blank"}
        do {
            try db.run(e.update(summary_ <- summary))}
        catch{
            print("summary update error")
        }
        if(TypeField.text?.isEmpty == false){
            type = TypeField.text
        }
        else{
            type = "blank"}
        do {
            try db.run(e.update(type_ <- type))}
        catch{
            print("type update error")
        }

//        getDataFromSqlite()
//        self.table.reloadData()
    }
    
}
