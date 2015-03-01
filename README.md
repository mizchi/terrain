# mz-terrain

Simple terrain generator by [Diamond-square algorithm](http://en.wikipedia.org/wiki/Diamond-square_algorithm "Diamond-square algorithm - Wikipedia, the free encyclopedia")

It's just rewrite by coffeescript, [Realistic terrain in 130 lines](http://www.playfuljs.com/realistic-terrain-in-130-lines/ "Realistic terrain in 130 lines")

## How to use

```
npm install mz-terrain
```

```coffee
Terrain = require 'mz-terrain'
terrain = new Terrain(7, 2) # detail, roughness
terrain.generate()
map = terrain.to2dArray()
for row in map
  xs = row
    .map (t) -> if t.val > 1 then '#' else ' '
    .join ''
  console.log xs
```

![](http://i.gyazo.com/fa53c6c9d3850b1dbe6e46a7416aa080.png)

## API

```javascript
declare class Terrain {
  constructor: (detail: number, roughness: number);
  generate(): void;
  toArray(): {x: number; y: number; val: number;}[];
  to2dArray(): {x: number; y: number; val: number;}[][];
}
```

## LICENSE

MIT
