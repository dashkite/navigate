import { navigate } from "@dashkite/navigate"

window.navigations = 0

do ->

  for await event from navigate window
    window.navigations++
