# terrain

MoonBit によるダンジョン生成アルゴリズム集。32種のアルゴリズムを収録。

## Algorithms

| # | Package | Algorithm | Style |
|---|---------|-----------|-------|
| 1 | `drunkard` | Drunkard's Walk | ランダムウォーク洞窟 |
| 2 | `cellular` | Cellular Automata | ライフゲーム風洞窟 |
| 3 | `bsp` | BSP Tree | 二分空間分割 (Nethack風) |
| 4 | `poisson` | Poisson Disk Sampling | ポアソン円盤配置 + MST接続 |
| 5 | `graph_grammar` | Graph Grammar | グラフ文法による鍵・錠構造 |
| 6 | `wfc` | Wave Function Collapse | 波動関数崩壊 (制約伝播タイル配置) |
| 7 | `diablo` | Diablo-style | Diablo風スパイン+分岐+ループグラフ |
| 8 | `spelunky` | Spelunky-style | Spelunky風グリッド上→下ランダムウォーク |
| 9 | `arena_chain` | Arena Chain | Hades/Dead Cells風 大部屋ジグザグ接続 |
| 10 | `voronoi` | Voronoi Region | Manhattan Voronoi分割 + MST |
| 11 | `maze` | Maze (DFS) | 再帰バックトラッカー完全迷路 |
| 12 | `rooms_and_mazes` | Rooms and Mazes | Bob Nystrom風 部屋+迷路+コネクタ |
| 13 | `radial` | Radial | 同心円リング + 放射スポーク (Darkest Dungeon風) |
| 14 | `dla` | DLA | 拡散律速凝集 (有機的洞窟) |
| 15 | `worm` | Worm Tunnels | 複数ワームエージェント掘削 |
| 16 | `rogue` | Rogue Classic | 初代Rogue風 3x3グリッド部屋配置 |
| 17 | `accretion` | Room Accretion | Brogue風 壁接着による有機的成長 |
| 18 | `tinykeep` | TinyKeep | TinyKeep風 散布+物理分離+三角分割+MST |
| 19 | `feature_growing` | Feature Growing | Tyrant風 壁からフィーチャーを生やす |
| 20 | `noise_caves` | Noise Caves | Perlin Noise風 閾値洞窟 (fBM) |
| 21 | `superimpose` | Superimposition | 重ね打ち (オーバーラップ許容) |
| 22 | `eller` | Eller's Maze | Eller法 行単位O(N)迷路 |
| 23 | `tunneler` | Parametric Tunnelers | Cogmind風 自己変化トンネラーエージェント |
| 24 | `bfs_rooms` | BFS Room Expansion | Red Blob Games風 BFS膨張ジグソー部屋 |
| 25 | `kruskal` | Kruskal's Maze | Kruskal法 エッジシャッフル+Union-Find迷路 |
| 26 | `recursive_division` | Recursive Division | 再帰分割 壁を置く逆アプローチ迷路 |
| 27 | `binary_tree` | Binary Tree Maze | 二分木迷路 (北or西の2択) |
| 28 | `sidewinder` | Sidewinder Maze | Sidewinder法 行単位ラン生成迷路 |
| 29 | `diamond_square` | Diamond-Square | 中点変位法 高さマップ閾値洞窟 |
| 30 | `space_colonization` | Space Colonization | 引力点ベース有機的分岐 (血管/樹木パターン) |
| 31 | `hilbert` | Hilbert Curve | ヒルベルト曲線 空間充填曲線ダンジョン |
| 32 | `prefab` | Prefab Assembly | テンプレート組み立て (T字路/十字路/L字等) |

## Usage

```bash
# Check
moon check --deny-warn

# Test
moon test

# Run (JS target)
moon build --target js
node _build/js/debug/build/main/main.js
```
