# Concurrency Examples

[Concurrency Concepts](concurrency_concepts.md)

> [!Note]
> For simplicity we're using anonymous functions but you can use your own custom functions
>

## Examples

- [Example 1: Go Routines and Channels](#example-1-go-routines-and-channels)
- [Example 2: Select Statement](#example-2-select-statement)
- [Example 3: Select Statement with multiple valid cases](#example-3-select-statement-with-multiple-valid-cases)
- [Example 4: Looping over channels](#example-4-looping-over-channels)

### Example 1: Go Routines and Channels

This example uses:

- 1 WaitGroup
- 1 channel to pass data between routines
- 2 anonymous functions that act as go routines.

```go
package main

import (
    "log"
    "sync"
)

func main() {
    var wg sync.WaitGroup
    ch := make(chan string)

    wg.Add(1)

    go func() {
        ch <- "Inut message"
    }()

    go func() {
        log.Println(<-ch)
        wg.Done()
    }()

    wg.Wait()
}
```

### Example 2: Select Statement

Select statement summary:

- The select statement waits for any of the communication cases to be ready (i.e., either sending or receiving on the channel).
- If multiple cases are ready at the same time, Go chooses one randomly to proceed. This random selection ensures fairness and avoids channel starvation.
- If none of the communication cases is ready and there is a default case, the code within the default case will execute.
- If there is no default case and none of the channel operations is ready, the select statement blocks until at least one of the cases is ready.

A select statement is similar to a switch statement but is geared toward listening to multiple channels. This allows us to receive and act on multiple inputs at the same time.

The following example will listen to several channels and execute a case statement whenever it receives a value on one of them. In the example cases, we spin off a goroutine to do something with the value so that we can continue the execution of our loop for the next value. If no value is present on the channel, this blocks until one is. If values are on more than one channel, select uses a pseudo-random method to select which case to execute:

```go
for {
     select {
    case v := <-inCh1:
        go log.Println("received(inCh1): ", v)
    case v := <-inCh2:
        go log.Println("received(inCh2): ", v)
     }

}
```

With a select statement, we sometimes only want to check if a value is on a channel, but if it is not, then we want to move on. In those cases, we can use a default statement. default executes if no other case statement can execute (versus the previous behavior of waiting for channel data indefinitely). You can see an example of this in the following code snippet:

```go
select {
case s := <-ch:
    log.Printf("had a string(%s) on the channel\n", s)
default:
    log.Println("The channel was empty")
}
```

Select has one more use we saw before but it wasn't explained. select{} has no case statements and no default statement; therefore, it blocks forever. This is often used by servers that want to run forever to prevent the main() function from exiting, which stops the execution of the program.

### Example 3: Select Statement with multiple valid cases

```go
package main

import (
    "log"
    "time"
)

func main() {
    ch1, ch2, ch3 := make(chan string), make(chan string), make(chan string)

    go func() {
        ch1 <- "Data for channel 1"
    }()

    go func() {
        ch2 <- "Data for channel 2"
    }()

    go func() {
        ch3 <- "Data for channel 3"
    }()

    time.Sleep(10 * time.Millisecond) // it causes the main function to pause for a period of time (10ms), this allows the scheduler to have enough time to recognize that it has multiple Goroutines to invoke, if we don't use this pause then case 3 will always be selected.

    select { // In this select both cases are valid and they will be randomly select by the scheduler
    case data := <-ch1:
        log.Println(data)
    case data := <-ch2:
        log.Println(data)
    case data := <-ch3:
        log.Println(data)
    default:
        log.Println("No available data.")
    }
}
```

### Example 4: Looping over channels

We use `str := <-ch` to receive data from a channel and pass it to a variable. More commonly when receiving variables, the `for` range syntax is used. This allows us to pull all the values out of a channel. An example using our preceding channel might look like this:

```go
for val := range ch { // Acts like a <-ch
     fmt.Println(val)
}
```

Channels must be closed so that no more data will be sent to them. This is done with the `close()` keyword. To close the preceding channel, we could do `close(ch)`, *clousure should always be done by the sender*. Closing a channel will cause a for range loop to exit once all values on the channel have been removed.

Let's use a channel to send words from one goroutine to another, as follows:

```go
package main

import (
    "fmt"
    "log"
)

func main() {
    log.Println("Channel for loop example 1")
    ch1 := make(chan int)

    go func() {
        for i := 1; i < 11; i++ {
            ch1 <- i
        }
        close(ch1) // Channels must be closed so that no more data will be sent to them, not closing a channel will result in a deadlock condition on runtime.
    }()

    for data := range ch1 {
        fmt.Println(data)
    }

    log.Println("Channel for loop example 2")
    ch2 := make(chan string, 1)
    go func() {
        for _, word := range []string{"hello", "world"} {
            ch2 <- word
        }
        close(ch2)
    }()

    for word := range ch2 {
        fmt.Println(word)
    }
}
```

Full example: [Looping over channels](https://go.dev/play/p/XwWU7N0nZia)
