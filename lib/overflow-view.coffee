module.exports =
class OverflowView
  constructor: (bufferRange, @editor) ->
    @createMarker(bufferRange)

  createMarker: (bufferRange) ->
    @marker = @editor.markBufferRange(bufferRange, invalidate: 'touch', persistent: false)
    @editor.decorateMarker(@marker, type: 'highlight', class: 'highlight-overflow')

  getOverflows: ->
    screenRange = @marker.getScreenRange()
    overflows = @editor.getTextInRange(@editor.bufferRangeForScreenRange(screenRange))

  containsCursor: ->
    cursor = @editor.getCursorScreenPosition()
    @marker.getScreenRange().containsPoint(cursor, false)

  destroy: ->
    @marker?.destroy()
    @marker = null
