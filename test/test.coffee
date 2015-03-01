Terrain = require '../index.coffee'

describe 'terragen', ->
  it 'should generate map', ->
    terrain = new Terrain(7, 2)
    terrain.generate()
    map = terrain.to2dArray()
    for row in map
      xs = row
        .map (t) -> if 0 < t.val < 5 then '#' else ' '
        .join ''
      console.log xs
