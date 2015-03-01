OverflowEditorView = null
views = []

module.exports =
  activate: ->
    @disposable = atom.workspace.observeTextEditors(@addViewToEditor)

  deactivate: ->
    @disposable.dispose()

    while view = views.shift()
      view.destroy()

  addViewToEditor: (editor) ->
    OverflowEditorView ?= require './overflow-editor-view'
    views.push new OverflowEditorView(editor)
