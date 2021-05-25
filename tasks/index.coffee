import * as t from "@dashkite/genie"
import preset from "@dashkite/genie-presets"

preset t

import assert from "assert/strict"

import FS from "fs/promises"
import Path from "path"
import express from "express"
import files from "express-static"
import * as _ from "@dashkite/joy"
import * as k from "@dashkite/katana"
import * as m from "@dashkite/mimic"
import * as atlas from "@dashkite/atlas"
import * as ma from "@dashkite/masonry"
import { pug } from "@dashkite/masonry/pug"
import { test, print } from "@dashkite/amen"
import * as cheerio from "cheerio"

importMap = (context) ->

  generator = await atlas.Reference.create "@dashkite/navigate", "file:."

  generator.dependencies.add await do ->
    atlas.Reference.create "@dashkite/amen", "file:../amen"

  $ = cheerio.load context.output
  $ "<script type = 'importmap'>"
    .prependTo "head"
    .text generator.map.toJSON atlas.jsdelivr
  $.html()

browserTest = (f) -> ->

  server = express()
    .get "/", (request, response) ->
      response.sendFile Path.resolve "build/node/test/index.html"
    .use files "."
    .listen()

  {port} = server.address()

  browser = await m.connect()

  await f {server, port, browser}

  await m.disconnect browser
  server.close()

t.define "html", ma.start [
  ma.glob "test/**/*.pug", "."
  ma.read
  ma.tr pug.render
  ma.tr importMap
  ma.extension ".html"
  ma.write "build/node"
]

t.after "build", "html"

t.define "browser:test", [ "build" ], browserTest ({browser, port}) ->

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

  await print results
