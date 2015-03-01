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
    if x < 0 or x > this.max or y < 0 or y > this.max
      return -1
    return this.map[x + this.size * y]

  set: (x, y, val) ->
    this.map[x + this.size * y] = val

  _divide: (size) ->
    [x, y] = []
    half = size / 2
    scale = @roughness * size
    if half < 1 then return

    `
    for (y = half; y < this.max; y += size) {
      for (x = half; x < this.max; x += size) {
        this._square(x, y, half, Math.random() * scale * 2 - scale);
      }
    }
    for (y = 0; y <= this.max; y += half) {
      for (x = (y + half) % size; x <= this.max; x += size) {
        this._diamond(x, y, half, Math.random() * scale * 2 - scale);
      }
    }
    `
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

  generate: () ->
    @set(0, 0, @max);
    @set(this.max, 0, @max / 2);
    @set(this.max, @max, 0);
    @set(0, this.max, @max / 2);
    @_divide(this.max);

terrain = new Terrain(3, 2)
terrain.generate()
console.log terrain.map
