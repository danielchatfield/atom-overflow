{CompositeDisposable} = require 'atom'
OverflowView = require './overflow-view'
OverflowTask = require './overflow-task'

module.exports =
class OverflowEditorView
  @content: ->
    @div class: 'overflow-wrapper'

  constructor: (@editor) ->
    @disposables = new CompositeDisposable
    @views = []
    @task = new OverflowTask()

    @disposables.add @editor.onDidChangePath =>
      @subscribeToBuffer()

    @disposables.add @editor.onDidChangeGrammar =>
      @subscribeToBuffer()

    @disposables.add atom.config.onDidChange 'editor.fontSize', =>
      @subscribeToBuffer()

    @disposables.add atom.config.onDidChange 'overflow.grammars', =>
      @subscribeToBuffer()

    @subscribeToBuffer()

    @disposables.add @editor.onDidDestroy(@destroy.bind(this))

  destroy: ->
    @unsubscribeFromBuffer()
    @disposables.dispose()
    @task.terminate()

  unsubscribeFromBuffer: ->
    @destroyViews()

    if @buffer?
      @bufferDisposable.dispose()
      @buffer = null

  subscribeToBuffer: ->
    @unsubscribeFromBuffer()

    if @overflowCurrentGrammar()
      @buffer = @editor.getBuffer()
      @bufferDisposable = @buffer.onDidChange => @updateOverflows()
      @updateOverflows()

  overflowCurrentGrammar: ->
    grammar = @editor.getGrammar().scopeName
    return true

  destroyViews: ->
    while view = @views.shift()
      view.destroy()

  addViews: (overflows) ->
    for overflow in overflows
      view = new OverflowView(overflow, @editor)
      @views.push(view)

  getPreferredLineLength: ->
    atom.config.get('editor.preferredLineLength',
      scope: @editor.getRootScopeDescriptor())

  updateOverflows: ->
    # Task::start can throw errors atom/atom#3326
    maxLineLength = @getPreferredLineLength()
    try
      @task.start @buffer.getText(), maxLineLength, (overflows) =>
        @destroyViews()
        @addViews(overflows) if @buffer?
    catch error
      console.warn('Error starting overflow task', error.stack ? error)
