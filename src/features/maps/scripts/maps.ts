import type { mapConfig } from "./mapScale";

const maps: (keyof typeof mapConfig)[] = [
  "abyss",
  "ascent",
  "bind",
  "breeze",
  "corrode",
  "fracture",
  "haven",
  "icebox",
  "lotus",
  "pearl",
  "split",
  "sunset",
];

const currentMapPool: (keyof typeof mapConfig)[] = [
  "abyss",
  "bind",
  "corrode",
  "haven",
  "pearl",
  "split",
  "sunset",
];
const outOfRotation = maps
  .map((map) => {
    const included = currentMapPool.includes(map);
    if (!included) return map;
  })
  .filter((map) => map !== undefined);
console.log(outOfRotation);

export { maps, currentMapPool, outOfRotation };
