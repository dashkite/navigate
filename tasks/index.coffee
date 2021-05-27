import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"
import browse from "@dashkite/genie-presets/browse"

preset t

import assert from "assert/strict"
import * as _ from "@dashkite/joy"
import * as m from "@dashkite/mimic"
import { test } from "@dashkite/amen"
import print from "@dashkite/amen-console"

t.after "build", "pug:with-import-map"

t.define "test", [ "build" ], browse ({browser, port}) ->
  results = await test "navigate", m.launch browser, [
    m.page
    m.goto "http://localhost:#{port}/"
    m.pause
    m.select "a"
    m.click
    m.pause
    m.evaluate -> window.navigations
    m.assert 1
  ]

  print results
