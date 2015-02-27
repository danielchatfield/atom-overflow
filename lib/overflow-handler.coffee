module.exports = (text, maxLineLength) ->
  row = 0
  overflows = []
  for line in text.split('\n')
    if line.length >= maxLineLength
      overflows.push([[row, maxLineLength], [row, line.length]])
    row++
  overflows
