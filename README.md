# Navigate

_Transforms browser navigation events into an async iterable._

## Install

`npm i @dashkite/navigate`

Bundle with your favorite bundler.

## Usage

Install for `document`:

```coffeescript
import {navigate} from "@dashkite/navigate"

do ->
  for await event from navigate document
    console.log "Navigated to #{window.location.href}"
```

Or use within any Web Components that will need to handle navigation events. Just pass the document fragment to `navigate`.

## API

### _navigate root_

Adds an event listener for link `click` events and determines whether they need to be routed internally or bubbled up to the browser. Produces events for each internal navigation.
