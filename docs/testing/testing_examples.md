# Testing Examples

[Testing Concepts](testing_concepts.md)

> [!Tips]
> Use `go test ./...` to run the entire test suite, `./...` is a special wildcard that when used in conjuction with the `go test` command allows the test runner to run all test test of the current directory and all its subdirectories (assuming that those subdirecotries contain subpackages).
>

## Examples

- [Example 1: Math Add test](#example-1-math-add-test)
- [Example 2: Greet Test](#example-2-greet-test)
  - [Example 3: Greet Test (TDT)](#example-3-greet-test-tdt)
- [Example 4: Email Suffix Test](#example-4-email-suffix-test)
  - [Example 5: Email Suffix Test (TDT)](#example-5-email-suffix-test-tdt)

### Example 1: Math Add test

- main.go:

    ```go
    package main

    func main() {

    }

    func Add(l, r int) int {
        return l + r
    }
    ```

- main_test.go:

```go
package main

import "testing"

func TestAdd(t *testing.T) {
    // Arrange
    l, r := 1, 2
    expect := 3

    // Act
    got := Add(l, r)

    // Assert
    if expect != got {
        t.Errorf("Failed to add %v and %v. Got %v but was expecting %v\n", l, r, got, expect)
    }
}
```

### Example 2: Greet Test

```go
package main

import (
    "fmt"
    "testing"
)

func Greet(name string) (string, error) {
    if name == "" {
        return "", fmt.Errorf("name was empty")
    }
    return "Hello " + name, nil
}

func TestGreet(t *testing.T) {
    name := "Bob"
    want := "Hello Bob"

    got, err := Greet(name)
    if got != want || err != nil {
        t.Fatalf("TestGreet(%s): got %q/%v, want %q/nil", name, got, err, want)
    }
}

```

#### Example 3: Greet Test (TDT)

```go
func TestGreet(t *testing.T) {
     tests := []struct{
          desc string // What we are testing
          name string // The name we will pass
          want string // What we expect to be returned
          expectErr bool // Do we expect an error
     }{
          {
               desc: "Error: name is an empty string",
               expectErr: true,
               // name and want are "", the zero value for string
          },
          {
               desc: "Success",
               name: "John",
               want: "Hello John",
               // expectErr is set to the zero value, false
          },
     }

     // Executes each test.
     for _, test := range tests {
          got, err := Greet(test.name)
          switch {
          // We did not get an error, but expected one
          case err == nil && test.expectErr:
               t.Errorf("TestGreet(%s): got err == nil, want err != nil", test.desc)
               continue
          // We got an error but did not expect one
          case err != nil && !test.expectErr:
               t.Errorf("TestGreet(%s): got err == %s, want err == nil", test.desc, err)
               continue
          // We got an error we expected, so just go to the next test
          case err != nil:
               continue
          }
          // We did not get the result we expected
          if got != test.want {
               t.Errorf("TestGreet(%s): got result %q, want %q", test.desc, got, test.want)
          }
     }
}
```

### Example 4: Email Suffix Test

- main.go

```go
package main

import (
    "strings"
)

// IsEmployee checks if a given email address ends with fake-company.local
func IsEmployee(address string) bool {
    return strings.HasSuffix(address, "@fake-company.local")
}
```

- main_test.go:

```go
func TestIsEmployee(t *testing.T) {
    // Single Test
    if IsEmployee("a@fake-company.local") == false {
        t.Errorf("Expected true but got false")
    }
}
```

#### Example 5: Email Suffix Test (TDT)

```go
func TestIsEmployee(t *testing.T) {

    // Table Driven Test (TDT)
    testCases := []struct {
        inputEmail   string
        expectedBool bool
    }{
        {
            "a@fake-company.local",
            true,
        },
        {
            "b@fake-company.local",
            true,
        },
        // The tests below are expected to return false as the suffix is not @fake-company.local
        {
            "a@google.com",
            false,
        },
        {
            "b@google.com",
            false,
        },
    }

    for _, testCase := range testCases {
        t.Run(testCase.inputEmail, func(t *testing.T) {
            actualOutput := IsEmployee(testCase.inputEmail)
            if actualOutput != testCase.expectedBool {
                t.Errorf("Expected IsEmployee(%s) to be %t, but got %t", testCase.inputEmail, testCase.expectedBool, actualOutput)
            }
        })
    }
}
```
