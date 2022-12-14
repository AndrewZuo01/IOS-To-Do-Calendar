//
//  EventController.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/25.
//

import EventKitUI
import EventKit
import UIKit
import SQLite3
import SQLite
import PieCharts
import Charts


class EventController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    let id_ = Expression<Int>("id")
    let title_ = Expression<String?>("title")
    let summary_ = Expression<String>("summary")
    let type_ = Expression<String>("type")
    let day = Expression<Int>("day")
    let month = Expression<Int>("month")
    let year = Expression<Int>("year")
    
    var backgroundImage: UIImageView!
    
    
    var id: Int!
    var dateDay: Int!
    var dateMonth: Int!
    var dateYear: Int!
    var eventTitle:String!
    var summary:String!
    var type:String!
    var selectedIndex:IndexPath!
    
    var theData:[Event] = []
    var theType:[String] = []
    var theNumber:[Int] = []
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var chart: PieChartView!
    @IBOutlet weak var PiechartLabel: UILabel!
    
    
    var numDataEntry = [PieChartDataEntry]()
    var colors = [UIColor.blue]
    
    func updateChartData(){
        checkData()
        let dataSet = PieChartDataSet(entries: numDataEntry,label: nil)
        chart.rotationEnabled = false
        let dataObject = PieChartData(dataSet: dataSet)
       
        dataSet.colors = colors as! [NSUIColor]
        if(theType.count > 0){
            PiechartLabel.text = "Events' type distribution"
        }
        chart.data = dataObject
    }
    func checkData(){
        for d in theData{
            let tmp = String(d.type)
            if(theType.contains(tmp)==false){
                theType.append(tmp)
                theNumber.append(1)
                
            }
            else{
                theNumber[theType.firstIndex(of: tmp) ?? 0] += 1
            }
        }
        addNewEntry()
        
    }
    func addNewEntry(){
        var tempCount = 0;
        for t in theType{
            let newDataEntry = PieChartDataEntry(value:0)
            newDataEntry.value = Double(theNumber[tempCount]);
            newDataEntry.label = t;
            numDataEntry.append(newDataEntry)
            let red:CGFloat = CGFloat(drand48())
            let green:CGFloat = CGFloat(drand48())
            let blue:CGFloat = CGFloat(drand48())
            var newColor = UIColor(red:red, green: green, blue: blue, alpha: 1.0)
                colors.append(newColor)
            tempCount += 1
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Date.text = Variable.shared.date
        table.dataSource = self
        table.delegate = self
//        table.register(TableCell.self, forCellReuseIdentifier: "TableCell")
        let dateArr = Variable.shared.date.components(separatedBy: " ")
        let realDateArr = dateArr[1].components(separatedBy: "-")
        dateYear = Int(realDateArr[2])
        dateMonth = Int(realDateArr[0])
        dateDay = Int(realDateArr[1])
        
        self.backgroundImage = UIImageView(image: UIImage(named: "background"))
        self.backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(self.backgroundImage, at: 0)
        
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!.resizingMode)
        chart.chartDescription?.text = ""
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.backgroundImage.frame = self.view.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        theData = []
        getDataFromSqlite()
        self.table.reloadData()
        theType = []
        theNumber = []
        numDataEntry = [PieChartDataEntry]()
        PiechartLabel.text = ""
        colors = [UIColor.blue]
        updateChartData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = storyboard!.instantiateViewController(withIdentifier: "EventDetails2") as! EventDetails2
        selectedIndex = indexPath
        let event = theData[selectedIndex.row]
        
        detail.id = event.id
        detail.eventTitle = event.eventTitle
        detail.summary = event.summary
        detail.type = event.type
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.EventTitle?.text  = theData[indexPath.row].eventTitle
        cell.EventType?.text = theData[indexPath.row].type
        var len = theData[indexPath.row].summary.count
        if(len < 200){
            cell.Summary?.text = theData[indexPath.row].summary
            cell.Summary?.numberOfLines = 0}
        else{
            let start = theData[indexPath.row].summary.index(theData[indexPath.row].summary.startIndex, offsetBy: 0)
            let end = theData[indexPath.row].summary.index(theData[indexPath.row].summary.startIndex, offsetBy: 200)
            let range = start..<end
            cell.Summary?.text = String(theData[indexPath.row].summary[range])
            cell.Summary?.numberOfLines = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){

            let eventID = theData[indexPath.row].id!
            print(eventID)
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
            self.table.deleteRows(at: [indexPath], with: .automatic)

        }
        
    }
    func getDataFromSqlite(){
        let path = Bundle.main.path(forResource: "Final", ofType: "db")!
        let db = try! Connection(path, readonly: false)
        let events = Table("events")
        let constrain = events.filter(year == dateYear && day == dateDay && month == dateMonth)
        do {
            let all = Array(try db.prepare(constrain))
            for e in all {
                print("id: \(try e.get(id_))")
                let m = Event(i: (try e.get(id_)), d: dateDay, m: dateMonth, y: dateYear, t: (try e.get(title_)!), s: (try e.get(summary_)), ty: (try e.get(type_)))
                theData.append(m)
            }
        } catch {
            print(error)
        }
    }

    @IBAction func addNewEvent(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detail = self.storyboard!.instantiateViewController(withIdentifier: "EventDetails") as! EventDetails
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    
}
