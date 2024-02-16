import * as Fn from "@dashkite/joy/function"
import * as It from "@dashkite/joy/iterable"
import * as Type from "@dashkite/joy/type"
import * as Pred from "@dashkite/joy/predicate"

# event helpers, adapted from:
# https://github.com/vuejs/vue-router/blob/dev/src/components/link.js

getLink = ( event ) ->
  link = undefined
  elements = event.composedPath()
  for element in elements
    if element.matches "[href]"
      link = element
      break
    if element.target == event.target
      break
  link

hasLink = ( event ) -> ( getLink event )?

hasKeyModifier = ({ altKey, ctrlKey, metaKey, shiftKey }) ->
  metaKey || altKey || ctrlKey || shiftKey

isRightClick = ( event ) -> event.button? && event.button != 0

isAlreadyHandled = ( event ) -> event.defaultPrevented

intercept = ( event ) ->
  event.preventDefault()
  event.stopPropagation()

toURL = ( event ) -> new URL getLink event

isCurrentLocation = ( url ) -> window.location.href == url.href

navigate = Fn.pipe [
  It.events "click"
  It.select hasLink
  It.reject Pred.any [
    hasKeyModifier
    isRightClick
    isAlreadyHandled
  ]
  It.tap intercept
  It.map toURL
  It.select Type.isDefined
  It.reject isCurrentLocation
]

export {navigate}
