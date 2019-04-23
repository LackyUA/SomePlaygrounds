import Foundation

/// Simple structs with replacing values in case of mutating.
struct Point {
    var x: Int
    var y: Int
}

extension Point {
    static let origin = Point(x: 0, y: 0)
    
    static func +(lhs: Point, rhs: Point) -> Point {
        return Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func +=(lhs: inout Point, rhs: Point) {
        lhs = lhs + rhs
    }
}

struct Size {
    var height: Int
    var width: Int
}

struct Rectangle {
    var origin: Point
    var size: Size
}

extension Rectangle {
    init(x: Int = 0, y: Int = 0, height: Int, width: Int) {
        origin = Point(x: x, y: y)
        size = Size(height: height, width: width)
    }
    
    mutating func translate(by offset: Point) {
        origin = origin + offset
    }
    
    func translated(by offset: Point) -> Rectangle {
        var copy = self
        copy.translate(by: offset)
        
        return copy
    }
}

let rect1 = Rectangle(origin: Point.origin, size: Size(height: 480, width: 320))

var screen = Rectangle(height: 480, width: 320) {
    didSet {
        print("Screen changed: \(screen)")
    }
}

var array = [Point(x: 0, y: 0), Point(x: 10, y: 10)]
array[0] += Point(x: 100, y: 100)

screen.origin.x = 10
screen.origin + Point(x: 10, y: 10)
screen.origin += Point(x: 0, y: 10)

screen.translate(by: Point(x: 10, y: 10))
let newScreen = screen.translated(by: Point(x: 10, y: 10))

func translatedByTenTen(rectangle: Rectangle) -> Rectangle {
    return rectangle.translated(by: Point(x: 10, y: 10))
}

screen = translatedByTenTen(rectangle: screen)

func translatedByTwentyTwenty(rectangle: inout Rectangle) {
    rectangle.translate(by: Point(x: 20, y: 20))
}

translatedByTwentyTwenty(rectangle: &screen)

var screens = [Rectangle(height: 480, width: 320)] {
    didSet {
        print("Array changed")
    }
}

screens[0].origin.x += 100

/// Copy-on-write structs.

// Collections.
var x = [1,2,3]
var y = x

x.append(5)
y.removeLast()
x
y

// Simple array.
var input: [UInt8] = [0x0b,0xad,0xf0,0x0d]
var other: [UInt8] = [0x0d]

var d = Data(_: input)
var e = d
d.append(contentsOf: other)

// After appending other to d it made copy of e and save it to d with new value.
d
e

// NSMutableData
var f = NSMutableData(bytes: &input, length: input.count)
var g = f
f.append(&other, length: other.count)

// In this case g and f refering to the same object in memory.
f
g
f === g

// If we wrap NSMutableData in a struct, we don’t get value semantics automatically.
struct MyDataStillReferenced {
    var _data: NSMutableData
    
    init(_ data: NSData) {
        self._data = data.mutableCopy() as! NSMutableData
    }
}

extension MyDataStillReferenced {
    func append(_ other: MyDataStillReferenced) {
        _data.append(other._data as Data)
    }
}

let theData = NSData(base64Encoded: "wAEP/w==", options: [])!
let a = MyDataStillReferenced(theData)
let b = a
a._data === b._data

a.append(a)
b
a._data === b._data

/// Methods to implement Copy-On-Write.
/// Copy-On-Write (The Expensive Way).

// Making _data private and mutating it through a computed property _dataForWriting.
struct MyExpensiveData {
    fileprivate var _data: NSMutableData
    var _dataForWriting: NSMutableData {
        mutating get {
            _data = _data.mutableCopy() as! NSMutableData
            return _data
        }
    }
    
    init(_ data: NSData) {
        self._data = data.mutableCopy() as! NSMutableData
    }
}

extension MyExpensiveData {
    mutating func append(_ newElement: MyExpensiveData) {
        _dataForWriting.append(newElement._data as Data)
    }
}

// Struct MyData has value semantics and we can copy data.
let theNewData = NSData(base64Encoded: "wAEP/w==", options: [])!
var n = MyExpensiveData(theNewData)
let m = n
n._data === m._data

n.append(n)
n._data === m._data

/// Copy-On-Write (The Efficient Way).

final class Box<A> {
    var unbox: A
    
    init(_ value: A) { self.unbox = value }
}

var k = Box(NSMutableData())
isKnownUniquelyReferenced(&k)

var l = k
isKnownUniquelyReferenced(&k)

struct MyEfficientData {
    fileprivate var _data: Box<NSMutableData>
    
    var _dataForWriting: NSMutableData {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {
                _data = Box(_data.unbox.mutableCopy() as! NSMutableData)
                print("Making a copy")
            }
            
            return _data.unbox
        }
    }
    
    init(_ data: NSData) {
        self._data = Box(data.mutableCopy() as! NSMutableData)
    }
}

extension MyEfficientData {
    mutating func append(_ newElement: MyEfficientData) {
        _dataForWriting.append(newElement._data.unbox as Data)
    }
}

let someBytes = MyEfficientData(NSData(base64Encoded: "wAEP/w==", options: [])!)
var empty = MyEfficientData(NSData())
var emptyCopy = empty

for _ in 0..<5 {
    empty.append(someBytes)
}

empty // <c0010fff c0010fff c0010fff c0010fff c0010fff>
emptyCopy // <>

/// Copy-On-Write Gotchas.

// Create empty class and struct with mutating method for checking whether or not the reference should be copied.
final class Empty {}

struct COWStruct {
    var ref = Empty()
    
    mutating func change() -> String {
        if isKnownUniquelyReferenced(&ref) {
            return "No copy"
        } else {
            return "Copy"
        }
        
        // Perform actual changes
    }
}

// No copies if its not shared reference
var i = COWStruct()
i.change()

// It creates copy if the reference is shred
var originalCOWStruct = COWStruct()
var copyCOWStruct = originalCOWStruct
originalCOWStruct.change()

// Same logic for adding value to array and then create new referenced value.
var structsArray = [COWStruct()]
structsArray[0].change()

var cop = structsArray[0]
cop.change()

var dict = ["key": COWStruct()]
dict["key"]?.change()

// When we directly access it, we get the copy-on-write optimization,
// but when we access it indirectly through a subscript, a copy is made.
struct ContainerStruct<A> {
    var storage: A
    
    subscript(s: String) -> A {
        get {
            return storage
        }
        
        set {
            storage = newValue
        }
    }
}

var h = ContainerStruct(storage: COWStruct())
h["test"].change()
h.storage.change()
