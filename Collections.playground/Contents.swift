import UIKit

// Arrays
var numbersArray: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
var namesArray: [String] = ["Dmytro", "Bogdan", "Roman", "Stas", "Nazar", "Yuriy", "Anton", "Volodymyr"]

// Mapping
let squares = numbersArray.map { $0 * $0 }

print(squares)

// Filtering
let filteringNumber = 50
let filteringLetter = "D"

let filteredSquareArray = squares.filter {$0 < filteringNumber}
let filteredNamesArray = namesArray.filter {$0 < filteringLetter}

print(filteredSquareArray)
print(filteredNamesArray)

// Contains
let searchingName = "Yuriy"

if filteredNamesArray.contains(searchingName) {
    print("Letter \"\(searchingName.first ?? " ")\" placed before letter \(filteringLetter) in ABC!")
} else {
    print("Letter \"\(searchingName.first ?? " ")\" placed after letter \(filteringLetter) in ABC!")
}

// Reduce
let sum = filteredSquareArray.reduce(3, +)
print(sum)

let allNames = namesArray.reduce("") { names, name in
    names + name + " "
}
print(allNames)

// For Each
["ko", "lya"].forEach { print($0) }

// Dictionaries
enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}
let defaultSettings: [String: Setting] = [
    "Airplane Mode": .bool(true),
    "Name": .text("My iPhone"),
]
print(defaultSettings["Name"]!)

var localizedSettings = defaultSettings
localizedSettings["Name"] = .text("Mein iPhone")
localizedSettings["Do Not Disturb"] = .bool(true)

let oldName = localizedSettings.updateValue(.text("Il mio iPhone"), forKey: "Name")
print(localizedSettings["Name"]!)
print(oldName!, "\n")

// Extension for merging dictionaries
extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
            for (k, v) in other {
                self[k] = v
            }
    }
}

var settings = defaultSettings
let overriddenSettings: [String: Setting] = ["Name": .text("Jane's iPhone")]
settings.merge(overriddenSettings)
print(settings, "\n")

// Extension for creating new dictionary from existed
extension Dictionary {
    init<S: Sequence>(_ sequence: S)
        where S.Iterator.Element == (key: Key, value: Value) {
            self = [:]
            self.merge(sequence)
    }
}

let defaultAlarms = (1..<5).map { (key: "Alarm \($0)", value: false) }
let alarmsDictionary = Dictionary(defaultAlarms)
print(alarmsDictionary, "\n")

// Extension for transforming value type into another type (Setting -> String in example)
extension Dictionary {
    func mapValues<NewValue>(transform: (Value) -> NewValue)
        -> [Key:NewValue] {
            return Dictionary<Key, NewValue>(map { (key, value) in
                return (key, transform(value))
            })
    }
}

let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case .text(let text):
        return text
    case .int(let number):
        return String(number)
    case .bool(let value):
        return String(value)
    }
}

print(settingsAsStrings)

// Hashable
struct Person {
    var name: String
    var zipCode: Int
    var birthday: Date
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
            && lhs.zipCode == rhs.zipCode
            && lhs.birthday == rhs.birthday
    }
}

extension Person: Hashable {
    var hashValue: Int {
        return name.hashValue ^ zipCode.hashValue ^ birthday.hashValue
    }
}

print (Person(name: "Dimas", zipCode: 76000, birthday: Date()) == Person(name: "Dimas", zipCode: 76000, birthday: Date()))

// Sets + SetAlgebra
let naturals: Set = [1, 2, 3, 2]
naturals.contains(3)
naturals.contains(0)

let drinks: Set = ["Tequila", "Coffee", "Tea", "Whiskey", "Bourbon", "Beer"]
let nonAlcoholDrinks: Set = ["Coffee", "Tea"]
let alcoholDrinks = drinks.subtracting(nonAlcoholDrinks)

let highAlcoholDrinks: Set = ["Whiskey", "Bourbon", "Vodka"]
let lowAlcoholDrinks = alcoholDrinks.intersection(highAlcoholDrinks)

var sweetWater: Set = ["Coca-cola", "Sprite"]
sweetWater.formUnion(nonAlcoholDrinks)
sweetWater

var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 11..<15)

let evenIndices = indices.filter { $0 % 2 == 0 }
evenIndices

// Sets inside closures
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter {
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}

[1,2,3,12,1,3,4,5,6,4,6].unique()

// Ranges
let singleDigitNumbers = 0..<10

let lowercaseLetters = Character("a")...Character("z")
