{View} = require 'atom'

module.exports =
class OverflowView extends View
  @content: ->
    @div class: 'column-overflow'

  initialize: (overflow, @editorView) ->
    @row = overflow[0]
    @startColumn = atom.config.get('column-overflow.column')
    @endColumn = overflow[1]

    @subscribe @editorView, 'editor:display-updated', =>
      @updatePosition()

    @updatePosition()

  updatePosition: ->
    @startPosition = @editorView.pixelPositionForBufferPosition([@row, @startColumn])
    @endPosition = @editorView.pixelPositionForBufferPosition([@row, @endColumn])
    @css
      top: @startPosition.top
      left: @startPosition.left
      width: @endPosition.left - @startPosition.left
      height: @editorView.lineHeight
    @show()

  destroy: ->
    @remove()
