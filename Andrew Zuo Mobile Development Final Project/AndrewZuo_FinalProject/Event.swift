//
//  Event.swift
//  AndrewZuo_FinalProject
//
//  Created by andrew on 2021/7/26.
//

import Foundation
class Event{
    var id:Int!
    var dateDay: Int!
    var dateMonth: Int!
    var dateYear: Int!
    var eventTitle:String!
    var summary:String!
    var type:String!
    init(i:Int,d:Int,m:Int,y:Int,t:String,s:String,ty:String) {
        self.id = i
        self.dateDay = d
        self.dateMonth = m
        self.dateYear = y
        self.eventTitle = t
        self.summary = s
        self.type = ty
    }
}
