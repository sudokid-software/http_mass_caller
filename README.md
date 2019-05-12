# HttpMassCaller

# Note about the application

This is not well suited for real testing of distributed HTTP calling. The system runs on a single system and should only be used for testing your own services.

I hold no responsibility for the miss use of this applicaiton.

## Run in terminal

The number following `CC` is the number of process that will be spawned.

`CC=10 iex -S mix run`

Once the application is running type you can type the following into the repl to send your request.

Both calls use the number `100` to tell the application to send `100` HTTP request to the URL `https://example.com`.

```
iex(12)> HttpMassCaller.Caller.spam(:post, "https://example.com", 100, %{"testing"=> "YEAH!!"})
:ok
iex(12)> HttpMassCaller.Caller.spam(:get, "https://example.com", 100)
:ok
```

## Installation

`mix deps.get`

