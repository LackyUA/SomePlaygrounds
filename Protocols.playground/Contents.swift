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

// Collection protocol implementation
extension FIFO: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

var q = FIFO<String>()
for x in ["KO", "1", "2", "foo", "3"] {
    q.enqueue(x)
}
q.dequeue()

for s in q {
    print(s, terminator: " ")
}

q.map { $0.uppercased() }
q.compactMap { Int($0) }
q.filter { $0.count > 1 }
q.sorted()
q.joined(separator: " ")

q.isEmpty
q.count
q.first

// Implement Expressible by array literal
extension FIFO: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self.init(left: elements.reversed(), right: [])
    }
}

let queue: FIFO = [1, 2, 3]

protocol Stack {
    associatedtype Element
    
    mutating func push(_: Element)
    mutating func pop() -> Element?
}

extension Array: Stack {
    mutating func push(_ x: Element) {
        append(x)
    }
    
    mutating func pop() -> Element? {
        return popLast()
    }
}

/// A simple linked list enum
enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

extension List {
    /// Return a new list by prepending a node with value `x` to the /// front of a list.
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}
// A 3-element list, of (3 2 1)
let list = List<Int>.end.cons(1).cons(2).cons(3)

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { partialList, element in partialList.cons(element) }
    }
}

let list2: List = [3,2,1]

extension List: Stack {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    
    mutating func pop() -> Element? {
        switch self {
        case .end:
            return nil
        case let .node(x, next: xs):
            self = xs
            return x
        }
    }
}

var stack: List<Int> = [3,2,1]
var a = stack
var b = stack

a.pop()
a.pop()
a.pop()

stack.pop()
stack.push(4)

b.pop()
b.pop()
b.pop()

stack.pop()
stack.pop()
stack.pop()

// Conforming List to Sequence
extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}

let list3: List = ["1", "2", "3"]
for x in list3 {
    print("\(x) ", terminator: "")
}

list3.joined(separator: ",")
list3.contains("2")
list3.compactMap { Int($0) }
list3.elementsEqual(["1", "2", "3"])

// Conforming List to Collection
/// Private implementation detail of the List collection
fileprivate enum ListNode<Element> {
    
    case end
    indirect case node(Element, next: ListNode<Element>)
    
    func cons(_ x: Element) -> ListNode<Element> {
        return .node(x, next: self)
    }
}

public struct ListIndex<Element>: CustomStringConvertible {
    fileprivate let node: ListNode<Element>
    fileprivate let tag: Int
    
    public var description: String {
        return "ListIndex(\(tag))"
    }
}

extension ListIndex: Comparable {
    public static func == <T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        return lhs.tag == rhs.tag
    }
    
    public static func < <T>(lhs: ListIndex<T>, rhs: ListIndex<T>) -> Bool {
        // startIndex has the highest tag, endIndex the lowest
        return lhs.tag > rhs.tag
    }
}

public struct List1<Element>: Collection {
    // Index's type could be inferred, but it helps make the rest of
    // the code clearer:
    public typealias Index = ListIndex<Element>
    
    public let startIndex: Index
    public let endIndex: Index
    
    public subscript(position: Index) -> Element {
        switch position.node {
        case .end:
            fatalError("Subscript out of range")
        case let .node(x, _):
            return x
        }
    }
    
    public func index(after idx: Index) -> Index {
        switch idx.node {
        case .end:
            fatalError("Subscript out of range")
        case let .node(_, next):
            return Index(node: next, tag: idx.tag - 1)
            
        }
    }
}

extension List1: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        startIndex = ListIndex(node: elements.reversed().reduce(.end) { partialList, element in
            partialList.cons(element)
        }, tag: elements.count)
        
        endIndex = ListIndex(node: .end, tag: 0)
    }
}

extension List1: CustomStringConvertible {
    public var description: String {
        let elements = self.map { String(describing: $0) }
            .joined(separator: ", ")
        return "List: (\(elements))"
    }
}

let list4: List1 = ["one", "two", "three"]
list4.first
list4.index(of: "two")


extension List1 {
    public var count: Int {
        return startIndex.tag - endIndex.tag
    }
}

list4.count

public func == <T: Equatable>(lhs: List1<T>, rhs: List1<T>) -> Bool {
    return lhs.elementsEqual(rhs)
}
