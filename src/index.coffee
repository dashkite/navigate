import {flow, pipe} from "@pandastrike/garden"
import Registry from "@dashkite/helium"
import * as r from "panda-river"

# event helpers, adapted from:
# https://github.com/vuejs/vue-router/blob/dev/src/components/link.js

isDefined = (x) -> x?

any = (fx) ->
  (x) ->
    for f in fx
      return true if f x
    false

# hasLink = (e) ->
#   for el in (path = e.composedPath())
#     return true if el.tagName == "A"

hasKeyModifier = ({altKey, ctrlKey, metaKey, shiftKey}) ->
  metaKey || altKey || ctrlKey || shiftKey

isRightClick = (e) -> e.button? && e.button != 0

isAlreadyHandled = (e) -> e.defaultPrevented

intercept = (event) ->
  event.preventDefault()
  event.stopPropagation()

# extract the element href if it has one
describe = (e) ->
  for el in e.composedPath()
    if el.tagName == "A"
      return url: el.href

isCurrentLocation = ({url}) -> window.location.href == url

origin = (url) -> (new URL url).origin

isCrossOrigin = ({url}) ->
  if window.location.origin != origin url
    # For non-local URLs, open the link in a new tab.
    window.open url
    true
  else
    false

getAlias = ({url}) ->
  if (match = getAliasKey url)? && (alias = aliases[match.key])?
    url: alias
  else
    {url}

browse = (destination) -> (Registry.get "router").browse destination

dispatch = (url) -> (Registry.get "router").dispatch {url}

click = flow [
  r.events "click"
  r.reject any [
    hasKeyModifier
    isRightClick
    isAlreadyHandled
  ]
  r.tee intercept
  r.map describe
  r.select isDefined
  r.reject any [
    isCurrentLocation
    isCrossOrigin
  ]
  r.each browse
]

navigate = (root) ->

  click root

  if root == document
    window.addEventListener "popstate", -> dispatch window.location.href

export {navigate}
