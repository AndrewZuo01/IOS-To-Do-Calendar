//
//  CalendarController.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/25.
//

import FSCalendar
import UIKit
import SQLite3
import SQLite

class CalendarController : UIViewController,FSCalendarDelegate,UITableViewDataSource, UITableViewDelegate{
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
    
    @IBOutlet weak var L1: UILabel!
    @IBOutlet weak var L2: UILabel!
    var backgroundImage: UIImageView!
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var recentTable: UITableView!
    var theData:[Event] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        recentTable.dataSource = self
        recentTable.delegate = self
//        recentTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.backgroundImage = UIImageView(image: UIImage(named: "background2"))
        self.backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(self.backgroundImage, at: 0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theData = []
        getRecentFromDatabase()
        if(theData.count == 0){
            L1.text = ""
            L2.text = ""
        }
        else{
            L1.text = "Events in 7 days"
            L2.text = "Date of incoming events"
        }
        self.recentTable.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backgroundImage.frame = self.view.bounds
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date);
        Variable.shared.date = string
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = self.storyboard!.instantiateViewController(withIdentifier: "EventController") as! EventController
        self.navigationController?.pushViewController(detail, animated: true)
    }
    func getRecentFromDatabase(){

        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var days = [Int]()
        for i in 1 ... 7 {
            let day = cal.component(.day, from: date)
            days.append(day)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        var jumpMonth:Bool = false
        var ii:Int! = 6
        for i in 0 ... 5 {
            if(days[i]>days[i+1]){
                jumpMonth = true
                ii = i
            }
        }
        let currentPageDate = calendar.currentPage

        var checkMonth = Calendar.current.component(.month, from: currentPageDate)
        var checkYear = Calendar.current.component(.year, from: currentPageDate)
        var newMonth:Int!
        var newYear:Int!
        if(jumpMonth == true && checkMonth == 12){
            newYear = checkYear + 1
        }
        else if(jumpMonth == true){
            newMonth = checkMonth + 1
            newYear = checkYear
        }
        let path = Bundle.main.path(forResource: "Final", ofType: "db")!
        let db = try! Connection(path, readonly: false)
        let events = Table("events")
        
        for i in 0 ... 6{
            if(ii+1 == i && jumpMonth == true){
                checkYear = newYear
                checkMonth = newMonth
            }
            let constrain = events.filter(year == checkYear && day == Int(days[i]) && month == checkMonth)
            do {
                let all = Array(try db.prepare(constrain))
                for e in all {
                    let m = Event(i: (try e.get(id_)), d: try e.get(day), m: try e.get(month), y: try e.get(year), t: ((try e.get(title_)!)), s: (try e.get(summary_)), ty: (try e.get(type_)))
                    theData.append(m)
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCellCalendar", for: indexPath) as! TableCellCalendar
        cell.Title.text = theData[indexPath.row].eventTitle
        var str:String = String(theData[indexPath.row].dateMonth)
        str.append("-")
        str.append(String(theData[indexPath.row].dateDay))
        str.append("-")
        str.append(String(theData[indexPath.row].dateYear))
        cell.Date.text = str
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){

            var eventID = theData[indexPath.row].id!
            let path = Bundle.main.path(forResource: "Final", ofType: "db")!
            let db = try! Connection(path, readonly: false)
            let events = Table("events")
            let deleteEvent = events.filter(id_ == eventID)
            do {
                if try db.run(deleteEvent.delete()) > 0 {
                    
                    if(Variable.shared.focusMode == true){
                        Variable.shared.money += 1}
                    if(Variable.shared.DeleteOnce){
                        let alert = UIAlertController(title: "Event Deleted!", message: "Now you got one coin, try buying pets and funiture in house screen!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        Variable.shared.DeleteOnce = false
                    }
                } else {
                    print("not found")
                }
            } catch {
                print("delete failed: \(error)")
            }
            self.theData.remove(at: indexPath.row)
            self.recentTable.deleteRows(at: [indexPath], with: .automatic)

        }
        
    }
}
