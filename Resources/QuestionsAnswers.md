# Questions and answers

## Protocols:
Protocols are a blueprint to implement methods, properties or requirements that a class, struct, or enum must adopt. They have no implementation of methods. The only case is for additional functionalities in an extension of the protocol.
Protocols can be composite like Codable that involves `Decodable & Encodable`.

```swift
protocol Vehicle {
    var numberOfWheels: Int { get }
    func start()
    func stop()
}

struct Car: Vehicle {
    var numberOfWheels: Int = 4

    func start() {
        print("Car started!")
    }

    func stop() {
        print("Car stopped!")
    }
}
```

## Extension:
As its word says, they are often used to extend the original functionality of an object.

```swift
//Following the Vehicle's protocol:
extension Vehicle {
    func getWheelsPressure() -> String {
        "The PSI is right in every wheel."
    }
}
```

## Enums:
Enums are widely used for a finite set of values or states.
We have `Associative Enums` that can attach additional data to each case and `Raw Value Enums` 

```swift
enum Weather {
    case sunny(temperature: Double)
    case rainy(inchesOfRain: Double)
    case cloudy
}

let currentWeather = Weather.sunny(temperature: 78.4)

switch currentWeather {
case .sunny(let temperature):
    print("It's sunny with a temperature of \(temperature)°F.")
case .rainy(let inchesOfRain):
    print("It's rainy with \(inchesOfRain) inches of rain.")
case .cloudy:
    print("It's cloudy.")
}
```
## Closures:
Closures are blocks of code that can be passed around and used like variables. Capturing values from their context and and being used to perform actions. Closures are often used as arguments for functions and methods, making code more expressive.

```swift
// Custom closure type: (Int, Double) -> Double
typealias PriceCalc = (Int, Double) -> Double

// Custom closure implementation: Calculates the total price by multiplying itemCount and itemPrice
let totalPriceClosure: PriceCalc = { itemCount, itemPrice in
    return Double(itemCount) * itemPrice
}

// Function that uses the custom closure
func calcTotalPrice(itemCount: Int, itemPrice: Double, priceCalculator: PriceCalc) -> Double {
    return priceCalculator(itemCount, itemPrice)
}

// Using the custom closure
let itemCount = 5
let itemPrice = 10.0

let totalPrice = calcTotalPrice(itemCount: itemCount, itemPrice: itemPrice, PriceCalc: totalPriceClosure)
print("Total Price: $\(totalPrice)") // Output: Total Price: $50.0

```

## Swift vs Objective-C:
`Swift` is a modern and expressive language with strong typing `(variables can be explicitly declared)` and Type Inference where swift's compiler can infer the data type of a variable based on its initial value. Error handling and optionals to enhance code reliability. ARC (Automatic Reference Counting) meaning automatic memory management.
`Objective-C` is an established, dynamic language that integrates well with C. It offers powerful runtime features and is suitable for legacy projects. It can also be gradually adopted in Swift projects.

## Struct vs Classes:
`Structs` are value type, meaning they can be copied and passed arround the code. Modifications in a copy don't affect the original. They do not support iheritance and are suitable for simple data models.
`Classes` are reference type meaning multiple variables can point to the same object in memory, have inheritance, they are deallocable and often used for complex data models.


