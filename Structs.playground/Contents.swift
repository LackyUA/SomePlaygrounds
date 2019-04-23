import UIKit

// Simple structs with replacing values in case of mutating.
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

// Copy-on-write structs.

