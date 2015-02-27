{Task} = require 'atom'

# Wraps a single {Task} so that multiple views reuse the same task but it is
# terminated once all views are removed.
module.exports =
class OverflowTask
  @activeViews: 0

  constructor: ->
    @constructor.task ?= new Task(require.resolve('./overflow-handler'))
    @constructor.activeViews++

  terminate: ->
    if --@constructor.activeViews is 0
      @constructor.task?.terminate()
      @constructor.task = null

  start: (args...) ->
    @constructor.task?.start(args...)
