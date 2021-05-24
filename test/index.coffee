import assert from "assert/strict"
import * as a from "amen"

import FS from "fs/promises"
import Path from "path"
import { patchFs as patchFS } from "fs-monkey"
import { vol as vfs } from "memfs"
import { ufs } from "unionfs"
import express from "express"
import files from "express-static"
import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as m from "@dashkite/mimic"

# module under test
import * as $ from "../src"

# vfs.fromJSON
#   "/app/index.html": """
#     <html>
#       <head>
#         <script type="module" src="/app/index.js"
#       </head>
#       <body></body>
#     </html>
#     """
#
# ufs
#   .use fs
#   .use vfs
#
# patchFS ufs

do ->

  server = express()
    # .use files "/app"
    .get "/", (request, response) ->
      response.send """
          <html>
            <head>
              <script type="module" src="/application.js"></script>
            </head>
            <body></body>
          </html>
          """
    .get "/application.js", (request, response) ->
      response.sendFile Path.resolve __dirname, "..", "..",
        "import/src/index.js"
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
      ]

  ]

  await m.disconnect browser
  server.close()

  process.exit 0
