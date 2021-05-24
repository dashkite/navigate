import * as f from "@dashkite/joy"
import * as i from "@dashkite/joy/iterable"
import * as t from "@dashkite/joy/type"
import * as p from "@dashkite/joy/predicate"

# event helpers, adapted from:
# https://github.com/vuejs/vue-router/blob/dev/src/components/link.js

notALink = (e) ->
  for el in e.composedPath()
    return false if el.tagName == "A"
  true

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

navigate = f.flow [
  i.events "click"
  f.pipe [
    i.reject p.any [
      hasKeyModifier
      isRightClick
      isAlreadyHandled
      notALink
    ]
    i.tap intercept
    i.map describe
    i.select t.isDefined
    i.reject p.any [
      isCurrentLocation
      isCrossOrigin
    ]
  ]
]

export {navigate}
