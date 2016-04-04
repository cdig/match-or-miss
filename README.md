# Match Or Miss

A simple game where you click a symbol with the corresponding name.

It's set up to use CodeKit, so if you have that then just open the project and hit **Preview**. If you don't have CK you can use pow(der): `cd` into the project folder and then `powder link`.

The hydraulic symbol content set is included by default. If you want to try it out with a different content set, replace the existing `public/content/*` with whatever images and `content.json` you want.

Here's an example of the format for the content file:

```json
{
  "title":"Schematic Symbols",
  "backgroundImage":"background.png",
  "handSize":4,
  "gameDuration":10,
  "promptText":"Pick the symbol named",
  "choices":[
    {"image":"symbols/working_pressure_line.png",
      "name":"Working Pressure Line"},
    {"image":"symbols/hydraulic_force.png",
      "name":"Hydraulic Energy Source"}
  ]
}
```

Reminder - tiles will start to overlap on small devices like phones. 5 is probably the max hand size to choose.


Copyright 2014-2016 CD Industrial Group Inc.
