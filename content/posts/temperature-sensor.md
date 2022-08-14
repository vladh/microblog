---
title: "Adding a Temperature Sensor to my Flat"
date: 2022-07-25T10:24:00+01:00
location: London, England
tags: [small-projects]
draft: false
---

I live in London now, and on the 18th and 19th of July this year, the UK saw its
highest recorded temperatures ever. The south-east of England was particularly
affected. I personally struggle a lot with heat, and knowing I would find
temperatures of up to 40°C unbearable, I escaped London to slightly chillier
Portsmouth.

However, before I left, I thought it would be really cool to see how the
temperature and humidity in the flat change during the heat wave while I'm away.
Luckily enough, I realised I had a Raspberry Pi Zero and a BME280 temperature
sensor, so I got to work putting them together. You can get the sensor [from
Adafruit](https://www.adafruit.com/product/2652) — it's easy to connect via I2C
and it seems to be quite well-supported when it comes to Linux drivers.
Here's what it all looks like.

![A Raspberry Pi connected to a temperature
sensor](https://vladh.net/static/microblog/sensor@800px.jpg "My Raspberry Pi
Zero connected to the BME280")

The next stop was to write some code to get the data off of the sensor. I put
together [something super quick in Go](https://git.sr.ht/~vladh/dewdrop) using
a driver someone had already written, and this allowed me to read the
temperature, humidity, and atmospheric pressure in a particular instant.

```go
package main

import (
	"time"
	"fmt"

	"golang.org/x/exp/io/i2c"

	"github.com/quhar/bme280"
)

func main() {
	d, err := i2c.Open(&i2c.Devfs{Dev: "/dev/i2c-1"}, bme280.I2CAddr)
	if err != nil {
		panic(err)
	}

	b := bme280.New(d)
	err = b.Init()
	temp, pres, hum, err := b.EnvData()
	if err != nil {
		panic(err)
	}

	fmt.Printf("date=%s ", time.Now().Format(time.RFC3339))
	fmt.Printf("temp=%f ", temp)
	fmt.Printf("pres=%f ", pres)
	fmt.Printf("hum=%f\n", hum)
}
```

I collected this data every second with a crontab, and sent it off to a
webserver. The next step was to make a small web page to interactively display
the live data. I normally would have built something custom with D3, but I
really didn't want to spend any time on this, so I just used
[an off-the-shelf plotting library](https://plotly.com/javascript/) to
[put something together real quick](https://git.sr.ht/~vladh/met.vladh.net).
Unfortunately, this resulted in a 4.4MB page size, but this page is really only
for my own use anyway, so whatever.

Here's what the result looks like! :)

![A graph of the temperature in my
flat](https://vladh.net/static/microblog/sensor-graph.png "A graph of the
temperature in my flat")

You can access the live version at [met.vladh.net](https://met.vladh.net), which
has real-time values from my flat, including humidity and atmospheric pressure.

Right away, I noticed some really interesting stuff in the data. First of all,
it's amazing how smoothly and regularly the temperature changed during Monday
and Tuesday, when I was away. I guess that, without any human intervention, and
in particular without any ventilation, the temperature changes quite gradually.

You probably noticed the sudden drop in temperature on the 20th, which is when
I got back home and opened all the windows. At this point it had gotten cooler
outside than it was inside, so ventilation really helped decrease the
temperature.

Since then, constant shuffling about and opening and closing windows seems to
cause constant spikes in temperature and humidity. I guess this makes sense, but
it's kind of cool and unexpected to see the magnitude of these changes.

The heat wave is (thankfully) long over, but it's going to be fun looking at
these graphs in the future!
