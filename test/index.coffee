import assert from "@dashkite/assert"
import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
# import * as m from "@dashkite/mimic"
# import { navigate } from "@dashkite/navigate"



do ->

  print await test "Navigate", [

    test "simple navigation"

  ]

  process.exit if success then 0 else 1

# TODO this would go into a client test file
# we would need to generate import maps

# window.navigations = 0

# do ->

#   for await event from navigate window
#     window.navigations++


# browse ({browser, port}) ->
#   results = await test "navigate", m.launch browser, [
#     m.page
#     m.goto "http://localhost:#{port}/"
#     m.pause
#     m.select "a"
#     m.click
#     m.pause
#     m.evaluate -> window.navigations
#     m.assert 1
#   ]

#   print results
