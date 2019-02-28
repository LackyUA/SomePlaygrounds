import UIKit

protocol Vehicle {
    var distanceDimension: DistanceDimension { get }
    
    var name: String { get }
    var model: String { get }
    var engineModification: String { get }
    var fuelType: String { get }
    
    var weight: Int { get }
    var maximumSpeed: Int { get set }
}

protocol Electric {
    var batteryCapacity: Int { get }
    var allElectricRange: Int { get set }
}

protocol Fuel {
    var positionOfEngine: String { get }
    var positionOfCylinders: String { get }
    
    var numberOfCylinders: Int { get }
    var cylinderBore: Int{ get }
}

enum DistanceDimension {
    case kilometer
    case mile
}

enum FuelType: String {
    case electricity = "Electricity"
    case fuel = "Fuel"
}

class Car: Vehicle {
    
    var distanceDimension: DistanceDimension
    
    var name: String
    var model: String
    var engineModification: String
    var fuelType: String
    
    var weight: Int
    var maximumSpeed: Int
    
    
    init(name: String, model: String, engineModification: String, fuelType: FuelType, weight: Int, maximumSpeed: Int, distanceDimension: DistanceDimension) {
        
        self.name = name
        self.model = model
        self.engineModification = engineModification
        self.fuelType = fuelType.rawValue
        self.weight = weight
        self.distanceDimension = distanceDimension
        
        switch distanceDimension {
            
        case .kilometer:
            self.maximumSpeed = maximumSpeed
            
        case .mile:
            self.maximumSpeed = Int(Double(maximumSpeed) * 1.60934)
            
        }
        
    }
}

class ElectricCar: Car, Electric {
    var batteryCapacity: Int
    var allElectricRange = Int()
    

    init(name: String, model: String, engineModification: String, fuelType: FuelType, weight: Int, maximumSpeed: Int, distanceDimension: DistanceDimension, batteryCapacity: Int, allElectricRange: Int) {
        
        self.batteryCapacity = batteryCapacity
        
        super.init(name: name, model: model, engineModification: engineModification, fuelType: fuelType, weight: weight, maximumSpeed: maximumSpeed, distanceDimension: distanceDimension)
        
        switch distanceDimension {
            
        case .kilometer:
            self.allElectricRange = allElectricRange
            
        case .mile:
            self.allElectricRange = Int(Double(allElectricRange) * 1.60934)
        }
    }
}

class FuelCar: Car, Fuel {
    var positionOfEngine: String
    var positionOfCylinders: String
    
    var numberOfCylinders: Int
    var cylinderBore: Int
    
    
    init(name: String, model: String, engineModification: String, positionOfEngine: String, positionOfCylinders: String, fuelType: FuelType, distanceDimension: DistanceDimension, weight: Int, maximumSpeed: Int, numberOfCylinders: Int, cylinderBore: Int) {
        
        self.positionOfEngine = positionOfEngine
        self.positionOfCylinders = positionOfCylinders
        self.numberOfCylinders = numberOfCylinders
        self.cylinderBore = cylinderBore
        
        super.init(name: name, model: model, engineModification: engineModification, fuelType: fuelType, weight: weight, maximumSpeed: maximumSpeed, distanceDimension: distanceDimension)
    }
}

let cars: [Car] = [Car(name: "BMW",
                       model: "Z8",
                       engineModification: "4.9",
                       fuelType: .fuel,
                       weight: 1660,
                       maximumSpeed: 250,
                       distanceDimension: .kilometer),
            
                   ElectricCar(name: "Tesla",
                               model: "Model S",
                               engineModification: "P100D",
                               fuelType: .electricity,
                               weight: 2300,
                               maximumSpeed: 156,
                               distanceDimension: .mile,
                               batteryCapacity: 100,
                               allElectricRange: 380),
                   
                   FuelCar(name: "Lamborghini",
                           model: "Diablo",
                           engineModification: "2.0 V12",
                           positionOfEngine: "Middle, longitudinal",
                           positionOfCylinders: "V engine",
                           fuelType: .fuel,
                           distanceDimension: .kilometer,
                           weight: 1625,
                           maximumSpeed: 330,
                           numberOfCylinders: 12,
                           cylinderBore: 87)]

func getInfo(about vehicle: Vehicle) {
    print("Name of vehicle is: \(vehicle.name) \(vehicle.model)")
}

cars.forEach { getInfo(about: $0) }

for car in cars {
    if let electricCar = car as? Vehicle & Electric {
        print("""
            \nBattery capacity in \(electricCar.name) \(electricCar.model): \(electricCar.batteryCapacity) kWh.
            All electric range: \(electricCar.allElectricRange).
            """)
    } else if let fuelCar = car as? FuelCar {
        print("""
            \nNumber of celinders in \(fuelCar.name) \(fuelCar.model): \(fuelCar.numberOfCylinders).
            Cylinder bore: \(fuelCar.cylinderBore).
            """)
    } else {
        print("\n\(car.name) \(car.model) is simple vehicle without electric or fuel classification.")
    }
}
