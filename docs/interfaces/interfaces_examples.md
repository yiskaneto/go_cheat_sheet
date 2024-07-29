# Interfaces Example

- [Type assertions](https://go.dev/tour/methods/15)

## Examples

- [Interfaces Example](#interfaces-example)
  - [Examples](#examples)
    - [Example 1: Shape Interface](#example-1-shape-interface)
    - [Example 2: interface of any type](#example-2-interface-of-any-type)
    - [Example 3: Assert Interface Type](#example-3-assert-interface-type)
    - [Example 4: Interface Composition](#example-4-interface-composition)
    - [Example 5: Errors on Interfaces](#example-5-errors-on-interfaces)

### Example 1: Shape Interface

```go
package main

import (
	"log"
	"math"
)

// Declare the interface
type Shape interface {
	Area() float64
}

// Declare the Rectangle and Circle structs
type Rectangle struct {
	width, height float64
}

type Circle struct {
	radius float64
}

// Declare the methods for Rectangle and Circle structs that implement the function(s) of the Shape interface
func (r Rectangle) Area() float64 {
	return r.width * r.height
}

func (c Circle) Area() float64 {
	return math.Pi * c.radius * c.radius
}

// Create a general function that takes in the Shape interface as its argument, for example here
// we can pass an instance of a struct that has a method that implements the Shape interface
// in our case that would be our Rectangle and Circle structs
func calculateArea(s Shape) float64 {
	return s.Area()
}

func main() {
	rect := Rectangle{width: 4, height: 8}
	circle := Circle{radius: 7}

	log.Println("Rectangle area:", calculateArea(rect))
	log.Println("Circle area:", calculateArea(circle))
}
```

### Example 2: interface of any type

We can create an interface on the fly which will accept any type

```go
func main() {
	// Declare a variable of type interface, in this case it will be of type int
	intInterface := interface{}(100)
	showInterfaceValue(intInterface) // Type: int. Value: 100

	// Declare a variable of type interface, in this case it will be of type slice of ints
	sliceIntInterface := interface{}([]int{1, 2, 3, 4})
	showInterfaceValue(sliceIntInterface) // Type: []int. Value: [1 2 3 4]

	// Interface of type map of strings
	mapStringInterface := interface{}(map[string]interface{}{"firstName": "Leif", "lastName": "Erikson"})
	showInterfaceValue(mapStringInterface) // Type: map[string]interface {}. Value: map[firstName:Leif lastName:Erikson]

	// Interface of type map of integers
	mapIntInterface := interface{}(map[int]interface{}{1: "One", 2: 2})
	showInterfaceValue(mapIntInterface) // Type: map[int]interface {}. Value: map[1:One 2:2]

}

func showInterfaceValue(t interface{}) {
	fmt.Printf("Type: %T. Value: %v\n", t, t)
}
```

### Example 3: Assert Interface Type

```go
func main() {
	// Declare a variable of type interface, in this case it will be of type int
	intInterface := interface{}(100)

	assertIntType, ok := intInterface.(int) // the dot between the intInterface variable and (int) instructs the compiler to asserts if intInterface is of type int.
	if ok {
		fmt.Printf("%v is of type int\n", assertIntType)
	} else {
		fmt.Printf("%v is NOT if type int\n", assertIntType)
	}

}

```

### Example 4: Interface Composition

We can embed multiple interfaces into 1, meaning we can group the methods of similar interfaces into 1 or more interfaces to better manage our interfaces, in this example we'll be embedding 2 interfaces into 1:

```go
// Declare the interface 1
type Shape interface {
	Area() float64
}

// Declare the interface 2
type Measurable interface {
	Perimeter() float64
}

// Declare the interface that will embed both the Shape and Measurable interfaces, which means that
// by using the Geometry interface we can refer to the struct methods implementing the Measurable and Shape interfaces
type Geometry interface {
	Shape
	Measurable
}

// Declare the Rectangle and Square structs
type Rectangle struct {
	width, length float64
}

type Square struct {
	side float64
}

// Declare the methods for the Rectangle and Square structs that implement the functions of the Shape and Measurable interface
func (r Rectangle) Area() float64 {
	return r.width * r.length // Formula: A=wl
}

func (r Rectangle) Perimeter() float64 {
	return 2 * (r.width + r.length) // Formula: P=2(l+w)
}

func (s Square) Area() float64 {
	return math.Pow(s.side, 2) // Formula: A=a**2
}

func (s Square) Perimeter() float64 {
	return s.side * 4 // Formula: P=4a
}

// showObjectData() accepts a Geometry interface which is composed of the Measurable and Shape interfaces
// hence we can pass an instance of a struct that implements the functions of the Measurable and Shape interfaces
func geometryDimensions(g Geometry) {
	fmt.Println("Area:", g.Area())
	fmt.Println("Perimeter:", g.Perimeter())
}

func main() {
	rect := Rectangle{width: 4, length: 8}
	square := Square{side: 20}

	geometryDimensions(rect)
	geometryDimensions(square)
```

### Example 5: Errors on Interfaces

```go
// Create a struct containing a msg field
type CalculationError struct {
	msg string
}

func (ce CalculationError) Error() string {
	if ce.msg == "" {
		return "msg field is empty"
	}
	return ce.msg
}

func (ce CalculationError) Info() string {
	return ce.msg
}

// One thing I didn't fully get is how by passing the CalculationError{msg: "Invalid input"} struct instance on the performCalculation() the performCalculation() would use the Error() method of the CalculationError struct, I would've thought that we would need to call the Error() method of the struct but this is not the case, so what I gather with this is that the compiler implicitly deduces that since we are returning a value of type error and because we're using the CalculationError{msg: "Invalid input value"} struct instance as its return value it "sees" that this struct instance has a method that implements the Error() function and hence it uses it.  So this is some sort of implicit default method for specific type returns or something like that, I honestly don't no how to refer to this behavior, I had no knowledge if this behavior but is good to know.

func performPowCalculation(val float64) (float64, error) {
	if val < 1 {
		return 0, CalculationError{}
		// it could also be:
		// return 0, CalculationError{msg: "Invalid input value"}
	}
	return math.Pow(val, 4), nil
}

func main() {
	fmt.Println(performPowCalculation(4))
	fmt.Println(performPowCalculation(0))
}
```
