# Concurrency Concepts

## Table of Contents

- [Sources](#sources)
- [Deadlock](#deadlock)
- [Channels](#channels)

### Sources

- [Go Concurrency Visually Explained — Channel](https://blog.stackademic.com/go-concurrency-visually-explained-channel-c6f88070aafa)
- [Deadlock in Go](https://www.naukri.com/code360/library/go-deadlock-and-select-statement)

### Deadlock

In simple terms `deadlock` means that the main function has no way to completing its work. A deadlock occurs when a set of goroutines are waiting for each other, and none can move forward. For instance, a deadlock occurs when a goroutine attempts to receive a message from an empty channel and has no other goroutines active. The "Receiver" goroutine, in this case, never receives a message.

### Channels

Channels provide a synchronization primitive in which data is inserted into a channel by a goroutine and removed by another goroutine. A channel can be:

- buffered (Asynchronous behavior): it can hold a certain amount of data before blocking
- unbuffered (Synchronous behavior): where a sender and receiver must both be present for the data to transfer between goroutines.

A common analogy for a channel is a pipe in which water flows. Water is inserted into a pipe and flows out the far side. The amount of water that can be held in the pipe is the buffer. Here, you can see a representation of goroutine communication using a channel:
![alt text](https://media.licdn.com/dms/image/D4D12AQGj5PuALp_rYQ/article-cover_image-shrink_600_2000/0/1686644477298?e=2147483647&v=beta&t=S5bkUKsp2uwTPRY_38aCRCDZ0DqZp55B6m2fjM_hYpk)

Channels are used to pass data from one goroutine to another, where the goroutine that passed the data stops using it. This allows you to pass control from one goroutine to another, giving access to a single goroutine at a time. This provides synchronization.

Channels are typed, so only data of that type can go into the channel. Because channels are a pointer-scoped type such as map and slice, we use make() to create them, as follows:

```go
ch := make(chan string, 1) // This is a buffered channel
```

The preceding statement creates a buffered channel called ch that holds a string type with a buffer of 1. Leaving ", 1" off will make it an unbuffered channel.
