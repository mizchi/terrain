flatten = require 'lodash.flatten'

module.exports =
class Terrain
  average = (values) ->
    valid = values.filter (val) -> val isnt -1
    total = valid.reduce ((sum, val) -> sum + val), 0
    total / valid.length

  constructor: (detail, @roughness) ->
    @size = Math.pow(2, detail) + 1
    @max = @size - 1
    @map = new Float32Array(@size * @size)

  get: (x, y) ->
    if x < 0 or x > @max or y < 0 or y > @max
      return -1
    return @map[x + @size * y]

  set: (x, y, val) ->
    @map[x + @size * y] = val

  generate: () ->
    @set(0, 0, @max);
    @set(@max, 0, @max / 2);
    @set(@max, @max, 0);
    @set(0, @max, @max / 2);
    @_divide(@max);

  _divide: (size) ->
    [x, y] = []
    half = size / 2
    scale = @roughness * size
    if half < 1 then return

    y = half
    while (y+=size) < @max
      x = half
      while (x+=size) < @max
        @_square(x, y, half, Math.random() * scale * 2 - scale);

    y = 0
    while (y+=size) < @max
      x = (y + half) % size
      while (x+=size) < @max
        @_diamond(x, y, half, Math.random() * scale * 2 - scale);
    @_divide(size / 2)

  _square: (x, y, size, offset) ->
    ave = average([
      @get(x - size, y - size),   # upper left
      @get(x + size, y - size),   # upper right
      @get(x + size, y + size),   # lower right
      @get(x - size, y + size)    # lower left
    ])
    @set(x, y, ave + offset);

  _diamond: (x, y, size, offset) ->
    ave = average([
      @get(x, y - size),      # top
      @get(x + size, y),      # right
      @get(x, y + size),      # bottom
      @get(x - size, y)       # left
    ])
    @set(x, y, ave + offset)

  to2dArray: ->
    for y in [0...@size]
      for x in [0...@size]
        { x, y, val: @get(x, y) }

  toArray: -> flatten @to2dArray()
