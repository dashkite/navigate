# Navigate

_Handle navigation events in browser applications and Web Components._

## Install

`npm i @dashkite/navigate`

Bundle with your favorite bundler.

## Usage

Install for the document:

```coffeescript
import {navigate} from "@dashkite/navigate"

navigate document
```

Also, install for any Web Components that will need to handle navigation events. Pass the document fragment fragment to `navigate`.

Navigate assumes you have added a `router` property to the Helium Registry. The returned value must support an Oxygen-compatible interface.

## API

### _navigate root_

Adds an event listener for click events and determines whether they need to be routed internally to the application. All other links will be opened in a new tab.
