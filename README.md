# Terrain

Simple terrain generator by [Diamond-square algorithm](http://en.wikipedia.org/wiki/Diamond-square_algorithm "Diamond-square algorithm - Wikipedia, the free encyclopedia")

It's just rewrite by coffeescript, [Realistic terrain in 130 lines](http://www.playfuljs.com/realistic-terrain-in-130-lines/ "Realistic terrain in 130 lines")

## How to use

```
npm install mizchi/terrain
```

```coffee
Terrain = require 'terrain'
terrain = new Terrain(7, 2)
terrain.generate()
map = terrain.to2dArray()
for row in map
  xs = row
    .map (t) -> if t.val > 1 then '#' else ' '
    .join ''
  console.log xs
```

![](http://i.gyazo.com/fa53c6c9d3850b1dbe6e46a7416aa080.png)

## LICENSE

MIT
