# Interfaces Example

- [Type assertions](https://go.dev/tour/methods/15)

## Examples

- [Interfaces Example](#interfaces-example)
  - [Examples](#examples)
    - [Example 1: Shape Interface](#example-1-shape-interface)
    - [Example 2: interface of any type](#example-2-interface-of-any-type)
    - [Example 3: Assert Interface Type](#example-3-assert-interface-type)

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
