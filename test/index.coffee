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

# module under test
import * as $ from "../src"

do ->

  reference = await atlas.Reference.create "@dashkite/navigate", "file:."

  server = express()
    # .use files "/app"
    .get "/", (request, response) ->
      response.send """
          <html>
            <head>
              <script type='importmap'>
                #{reference.map.toJSON atlas.jsdelivr}
              </script>
              <script type="module" src="/application.js"></script>
            </head>
            <body><a href="#foo">Foo</a></body>
          </html>
          """
    .get "/application.js", (request, response) ->
      response.set "Content-Type", "application/javascript"
      response.send """
        import { navigate } from "@dashkite/navigate"
        window.navigations = 0;
        (async function () {
          for await (let event of await navigate(window)) {
            window.navigations++;
          }
        })()
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
