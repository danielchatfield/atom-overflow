OverflowEditorView = null

module.exports =
  activate: ->
    console.log('activate');
    @disposable = atom.workspace.observeTextEditors(addViewToEditor)

  deactivate: ->
    @disposable.dispose()

addViewToEditor = (editor) ->
  OverflowEditorView ?= require './overflow-editor-view'
  new OverflowEditorView(editor)
