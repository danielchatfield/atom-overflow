describe "Overflow", ->
  [workspaceElement, editor, editorElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('language-text')

    waitsForPromise ->
      atom.packages.activatePackage('language-javascript')

    runs ->
      atom.config.set('editor.preferredLineLength', 10)

    waitsForPromise ->
      atom.workspace.open('sample.js')

    waitsForPromise ->
      atom.packages.activatePackage('overflow')

    runs ->
      jasmine.attachToDOM(workspaceElement)
      editor = atom.workspace.getActiveTextEditor()
      editorElement = atom.views.getView(editor)

  it "decorates all overflowing lines", ->
    editor.setText("This is a test\n This is also a test\n")

    decorations = null

    waitsFor ->
      decorations = editor.getHighlightDecorations(class: 'highlight-overflow')
      decorations.length > 0

    runs ->
      expect(decorations.length).toBe 2
      expect(decorations[0].marker.getBufferRange()).toEqual [[0, 10], [0, 14]]
      expect(decorations[1].marker.getBufferRange()).toEqual [[1, 10], [1, 20]]

  describe "when the editor is destroyed", ->
    it "destroys all overflow markers", ->
      editor.setText('this is a test')

      waitsFor ->
        editor.getHighlightDecorations(class: 'highlight-overflow').length > 0

      runs ->
        editor.destroy()
        expect(editor.getMarkers().length).toBe 0

  describe "when the package is disabled", ->
    it "destroys all overflow markers", ->
      editor.setText('this is a test')

      waitsFor ->
        editor.getHighlightDecorations(class: 'highlight-overflow').length > 0

      waitsForPromise ->
        atom.packages.deactivatePackage('overflow')

      runs ->
        expect(editor.getMarkers().length).toBe 0
