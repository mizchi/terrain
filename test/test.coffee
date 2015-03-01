Terrain = require '../index'

describe 'terragen', ->
  it 'should generate map', ->
    terrain = new Terrain(7, 2)
    terrain.generate()
    map = terrain.to2dArray()
    for row in map
      xs = row
        .map (t) -> if t.val > 1 then '#' else ' '
        .join ''
      console.log xs
