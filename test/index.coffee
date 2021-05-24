import assert from "assert/strict"
import * as a from "amen"

import FS from "fs/promises"
import Path from "path"
import express from "express"
import files from "express-static"
import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as m from "@dashkite/mimic"
import * as atlas from "@dashkite/atlas"
import {pug} from "@dashkite/masonry/pug"
import {coffee} from "@dashkite/masonry/coffee"

# module under test
import * as $ from "../src"

compile = coffee target: "import"

do ->

  reference = await atlas.Reference.create "@dashkite/navigate", "file:."

  server = express()
    .get "/", (request, response) ->
      response.send pug.render
        target: "import"
        input: """
          html
            head
              script(type = "importmap").
                #{_.collapse reference.map.toJSON atlas.jsdelivr}
              script(type = "module" src = "/application.js")
            body
              a(href = "#foo") Foo
          """
    .get "/application.js", (request, response) ->
      response.set "Content-Type", "application/javascript"
      response.send compile
        input: """
          import { navigate } from "@dashkite/navigate"
          window.navigations = 0
          do ->
            for await event from await navigate window
              window.navigations++
          """
    .use files "."
    .listen()

  {port} = server.address()

  browser = await m.connect()

  a.print await a.test "Navigate", [

    a.test
      description: "navigate"
      wait: false
      m.launch browser, [
        m.page
        m.goto "http://localhost:#{port}/"
        m.select "a"
        m.click
        m.evaluate -> window.navigations
        m.assert 1
      ]

  ]

  await m.disconnect browser
  server.close()

  process.exit 0
