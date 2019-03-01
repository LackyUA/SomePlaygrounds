import UIKit
import CoreData

protocol Model: AnyObject {
    var name: String { get }
    var surname: String { get }
}

protocol Task {
    var name: String { get }
    var estimate: Estimate { get set }
}

protocol Developing {
    var frameworks: [String] { get set }
}

protocol Designing {
    var software: [String] { get set }
}

protocol Query {
    associatedtype Element
    mutating func enqueue(_ newElement: Element)
    mutating func dequeue() -> Element?
    func getElementsInQueue() -> [Element]
}

struct FIFO<Element>: Query {
    private var left = [Element]()
    private var right = [Element]()
    
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        
        return left.popLast()
    }
    
    func getElementsInQueue() -> [Element] {
        return right
    }
}

struct LIFO<Element>: Query {
    private var query = [Element]()
    
    mutating func enqueue(_ newElement: Element) {
        query.append(newElement)
    }
    
    mutating func dequeue() -> Element? {
        return query.popLast()
    }
    
    func getElementsInQueue() -> [Element] {
        return query
    }
}

struct Estimate {
    var beginning: Date
    var end: Date
}

struct Design: Task, Designing {
    var name: String
    var estimate: Estimate
    var software: [String]
}

struct Application: Task, Developing {
    var name: String
    var estimate: Estimate
    var frameworks: [String]
}

class Employee: Model {
    var name: String
    var surname: String
    var tasks: [Task]
    
    init(name: String, surname: String, tasks: [Task]) {
        self.name = name
        self.surname = surname
        self.tasks = tasks
    }
}

func minutes(value: Int) -> TimeInterval {
    return TimeInterval(exactly: value * 60) ?? 0
}

func hours(value: Int) -> TimeInterval {
    return TimeInterval(exactly: minutes(value: value) * 60) ?? 0
}

func days(value: Int) -> TimeInterval {
    return TimeInterval(exactly: hours(value: value) * 24) ?? 0
}

let juniorJavaDeveloper = Employee(name: "Nikola",
                                   surname: "Tesla",
                                   tasks: [Application(name: "Compiler",
                                                       estimate: Estimate(beginning: Date(timeInterval: -days(value: 10), since: Date()),
                                                                          end: Date(timeInterval: hours(value: 5), since: Date())),
                                                       frameworks: ["JavaLint", "JavaCoreKit"]),
                                           Application(name: "Javicon",
                                                       estimate: Estimate(beginning: Date(timeInterval: -days(value: 1), since: Date()),
                                                                          end: Date(timeInterval: days(value: 3), since: Date())),
                                                       frameworks: ["JavaLint", "JSON parser"])
                                   ]
)

let middleDesigner = Employee(name: "Jorge",
                              surname: "Washingtone",
                              tasks: [Design(name: "Compiler",
                                             estimate: Estimate(beginning: Date(timeInterval: -days(value: 15), since: Date()),
                                                                end: Date(timeInterval: -days(value: 10), since: Date())),
                                             software: ["Sketch", "Photoshop"]),
                                      Design(name: "Swifty",
                                             estimate: Estimate(beginning: Date(timeInterval: -days(value: 5), since: Date()),
                                                                end: Date(timeInterval: minutes(value: 15), since: Date())),
                                             software: ["Sketch", "Paint"])
                              ]
)

for worker in [juniorJavaDeveloper, middleDesigner] {
    worker.tasks.forEach {
        print("Application: " + $0.name)
        print("Estimate: \($0.estimate)")
        
        if let developer = $0 as? Developing {
            print("Used frameworks: \(developer.frameworks)\n")
        } else if let designer = $0 as? Designing {
            print("Used software: \(designer.software)\n")
        }
    }
}


var FIFOquery = FIFO<Model>()
var LIFOquery = LIFO<Model>()

[juniorJavaDeveloper, middleDesigner].forEach {
    FIFOquery.enqueue($0)
    LIFOquery.enqueue($0)
}

FIFOquery.getElementsInQueue().forEach {
    print("Enqueued FIFO worker: " + $0.name + " " + $0.surname)
}
print("")

LIFOquery.getElementsInQueue().forEach {
    print("Enqueued LIFO worker: " + $0.name + " " + $0.surname)
}
print("")

if let worker = FIFOquery.dequeue() {
    print("Dequeued FIFO worker: \(worker.name) \(worker.surname)" )
}
print("")

if let worker = LIFOquery.dequeue() {
    print("Dequeued LIFO worker: \(worker.name) \(worker.surname)" )
}
