# YAIOM
Factorio mod, Yet Another Infinite Ore Mechanic

Having issues finding reliable ore spots farther and farther away? Want some sustainable but non-trivial ore sources?

Look no further.

## Hydraulic fracturing

When you generate a map with this mod on, you may notice that there's blue/green/pink/... ores on the map generation preview, but once you're within the game, you can't find them.

![](https://i.imgur.com/3dhc8rB.png)

Well, that's because they're generated deep underground, and you'll need to extract them if you want to reach them. And scan them first for their location so you can even see them.

Researching **Hydraulic fracturing** (fracking) will unlock a *Deep soil scanner* that scans the floor for gravimetric fluctuations deep underground, in the same radius as a basegame radar's active coverage (7x7 chunks). The miners for the ores are unlocked with further research (once you research the means to process any deep ore).

![](https://i.imgur.com/c2vENpj.png)

*Note: Ore quantities are exaggerated on this image for display purposes.*

Place one down and let it run, as they take a while. Each scanner takes at most around an hour in real time to finish scanning to its fullest width (2 minutes per chunk), and then deconstruct itself once done. 

Deep soil scanners won't scan chunks that have already been scanned (and revealed any deep ores), so spamming them around the terrain is the most efficient way to uncover the hidden ore.

### Satellite coverage

If you're tired of having to place and move scanners around, there's the **Orbital deep soil scanning** research which unlocks the means to use satellites to also scan the soil over time, getting faster the more satellites you have.

But to make this happen you'll need to place a *Satellite beacon* on the surface you wish to scan and wait, as each passive scan takes a whole Factorio day (~7 minutes), **but can reveal several chunks at once** depending on how many satellites you have in orbit. Just, don't place more than one beacon at a time. Trust me on this one.

## Orichalcum ore

The main mythical ore you find deep underground, being a mixture of hydro-carbonates and traces of both weak ferric and cupric acids. It shows on the minimap as a light blue, for ease of visibility. **In the basegame, it can produce copper, iron, oil side-products and eventually coal.**

Requires **light oil** to extract it from the floor, where high yields will require less oil per 1lu of orichalcum sludge (at the mininum yield, you get 1 sludge per 1 light oil used).

An early game setup for the sludge may look like this:

![](https://i.imgur.com/O8LqFss.png)

While a late game setup, requiring more research, may look like this:

![](https://i.imgur.com/n6UtThj.jpg)

*Note*: The earlier setup may still be of use even after unlocking the advanced ore refining, seeing that you get 1:1 on the return of petroleum gas, while you lose on maximum petroleum gas yield with the advanced setup.

## Yet to come

- Better graphics. I know, tinting stuff blue is my signature by now but it looks groddy.
- Adding dedicated support for big modpacks, such as adding a separate deep ore for tin-lead or integrating with Angel's ore processing more tightly.

## Bugs

Report on [my github](https://github.com/dustine/factorio-yaiom) or on [the forum post for this mod](https://forums.factorio.com/56737). Don't forget to include your savegame, the log file(s), a zip folder with all of your currently using mods, and to describe what you were doing before the bug happened.

## Credits
- [Katherine of Skies](https://www.youtube.com/channel/UCTIV3KbAvaGEyNjoMoNaGtQ)'s community for the mod idea and support
- Various members on the Factorio Discord and IRC for handling my rambling about
- Arch666Angel, for the placeholder graphic for the beacon