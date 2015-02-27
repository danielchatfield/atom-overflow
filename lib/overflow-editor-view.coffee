{View} = require 'atom'
OverflowView = require './overflow-view'

module.exports =
class OverflowEditorView extends View

  @content: ->
    @div class: 'overflow-wrapper'

  initialize: (@editorView) ->
    @views = []

    @subscribe @editorView, 'editor:path-changed', =>
      @subscribeToBuffer()

    @subscribe atom.config.observe 'overflow.column', callNow: false, =>
      @subscribeToBuffer()

    @subscribeToBuffer()

  beforeRemove: ->
    @unsubscribeFromBuffer()

  unsubscribeFromBuffer: ->
    @destroyViews()

    if @buffer?
      @unsubscribe @buffer
      @buffer = null

  subscribeToBuffer: ->
    @unsubscribeFromBuffer()

    @buffer = @editorView.getEditor().getBuffer()

    @subscribe @buffer, 'contents-modified', =>
      @updateOverflows()

    @updateOverflows()

  destroyViews: ->
    while view = @views.shift()
      view.destroy()

  updateOverflows: ->
    @destroyViews()

    overflows = @findOverflows()
    for overflow in overflows
      view = new OverflowView(overflow, @editorView)
      @views.push view
      @append view

  findOverflows: ->
    column = atom.config.get('overflow.column')
    text = @buffer.getText()
    overflows = []
    row = 0
    for line in text.split '\n'
      if line.length >= column
        overflows.push [row, line.length]
      row++
    overflows

  destroy: ->
    @unsubscribeFromBuffer()
    @detach()
