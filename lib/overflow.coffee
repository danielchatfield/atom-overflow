OverflowEditorView = require './overflow-editor-view'
{CompositeDisposable} = require 'atom'

views = []
active = true

module.exports = Overflow =
  overflowEditorView: null
  modalPanel: null
  subscriptions: null
  configDefaults:
    lineWidth: 80

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'overflow:toggle': => @toggle()

  deactivate: ->
    @subscriptions.dispose()
    @overflowEditorView.destroy()

  updateViews: ->
    atom.workspaceView.eachEditorView (editorView) ->
      if editorView.attached and editorView.getPane()
        view = new OverflowEditorView(editorView)
        views.push(view)
        editorView.underlayer.append(view)

  destroyViews: ->
    while view = views.shift()
      view.destroy()

  toggle: ->
    active = not active
    if active
      @updateViews()
    else
      @destroyViews()
