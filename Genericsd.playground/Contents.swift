import UIKit

protocol Employee {
    var name: String { get }
    var position: String { get }
    
    associatedtype Project
    var projects: [Project] { get set }
    mutating func start(project: Project, with estimate: TimeInterval)
    mutating func end(project: Project, with spentTime: TimeInterval)
    func developingProjects() -> [Project]
}

protocol Project {
    var name: String { get }
    var customer: String { get }
}

protocol Developing {
    var frameworks: [String] { get }
}

protocol Designing {
    var software: [String] { get }
}

struct Soft: Project, Developing {
    var name: String
    var customer: String
    var frameworks: [String]
}

struct Design: Project, Designing {
    var name: String
    var customer: String
    var software: [String]
}

struct Developer: Employee {
    var name: String
    var position: String
    var projects: [Soft]
    
    mutating func start(project: Soft, with estimate: TimeInterval) {
        projects.append(project)
    }
    
    mutating func end(project: Soft, with spentTime: TimeInterval) {
        projects = projects.filter { $0.name != project.name }
    }
    
    func developingProjects() -> [Soft] {
        projects.forEach { print($0) }
        return projects
    }
}

var dimasick = Developer(name: "Dmytro", position: "iOS Developer", projects: [])
let swifty = Soft(name: "Swifty", customer: "John Holder", frameworks: ["Firebase", "SwiftyJSON", "Core Data"])
let pipe = Soft(name: "Pipe", customer: "Radio records", frameworks: ["Firebase", "Snap Kit", "User Notifications"])

dimasick.start(project: swifty, with: 40.5)
dimasick.start(project: pipe, with: 77.3)
print("Projects in development:")
dimasick.developingProjects()

dimasick.end(project: pipe, with: 22.9)
print("\nFinished projects:")
dimasick.developingProjects()

struct DesignList<T> {
    var designs: [T]
    
    mutating func add(design: T) {
        designs.append(design)
    }
    
    mutating func removeLast() -> T {
        return designs.removeLast()
    }
    
    func designsCount() -> Int {
        return designs.count
    }
}

var designList = DesignList<Design>(designs: [])
designList.add(design: Design(name: "Swifty", customer: "John Holder", software: ["Sketch"]))
designList.add(design: Design(name: "Pipe", customer: "Radio records", software: ["Photo Shop", "Sketch"]))

designList.designsCount()

print("\n" + "\(designList.removeLast())")

designList.designsCount()
