

1clickBOM is purchasing tool that let's you keep _one_ bill of materials (BOM)
for items from _multiple_ retailers. It's a browser extension that fills your
online shopping carts for you. To add items to 1clickBOM you simply paste from
a spreadsheet or visit an online `.tsv` file.

## Which browsers? Which retailers? ##

Currently supported retailers are:

* Digikey
* Mouser
* Farnell/Element14
* Newark
* RS

As of now 1clickBOM is only available for Chrome/Chromium but a Firefox version
is planned.  Check the [roadmap][1] for more details on planned features.

## Usage ##

### Adding Items ###

You should arrange items in your spreadsheet in the following order.

    line-note | quantity | retailer | part-number

Line-note can be anything you like. I normally use schematic references.
Retailer is a name of one of the supported retailers and part-number is the
part-number specific to that retailer. See the [example tsv][2].

In your spreadsheet select the relevant columns, copy and then click the paste
button on the 1clickBOM popup.

![Load from page](https://raw.githubusercontent.com/monostable/1clickBOM/master/readme_images/load_from_page.png)

Alternatively, if you visit a page that ends in `.tsv` and has data in the
right format available 1clickBOM will show a blue badge and button with an
arrow. Press the blue button in the popup and the data will be added. You can
try this on the [example tsv page][2] once you have the extension installed.

### Then What? ###

Once the data is added you can use 1clickBOM to add the items to your carts
using the buttons on the popup. You can also quickly view and empty your carts.

## Roadmap ##

* 0.1
    * Chrome support
    * Digikey, Mouser, Farnell, Newark and RS
    * Allow clearing and viewing individual carts
    * Paste TSV or visit online `.tsv` file
    * Auto-merge multiple entries of the same component

* 0.2
    * Firefox support

* 0.3
    * Allied and Arrow
    * Display cart summaries
    * Warn about filling already filled carts
    * Allow adding components to BOM from the component page
    * Export BOM

* 1.0
    * Function to minimize order cost + shipping
    * Allow for multiple vendors per item
    * Allow additional unused fields in TSV, named columns?
    * Autofind same items from different vendors

* 2.0
    * Include PCB order

* 3.0
    * 3D-chip-printer support

* 4.0
    * Communicate through quantum entanglement

## Development ##

### Build and Test Requirements ###

The code is available on [Github][7]. 1clickBOM is written in [Coffeescript][4]
which transpiles to Javascript.  Currently development is done on Chromium.

### Build and Test Instructions ###

To transpile the coffeescript to javascript run `cake build` the chrome
directory. Run `cake` with no arguments for help. The code can then be loaded
as an unpacked extension in the developer mode in Chrome/Chromium settings.

Unit and functional tests are written using the [QUnit framework][5]. Tests
can be run by opening a javascript console on the background page and executing
the `Test()` function.

## License ##

1clickBOM is licensed under the CPAL license which means you can use the code
in proprietary applications as long as you display appropriate attribution and
license your improvements to 1clickBOM under the CPAL too. See the [LICENSE][6]
file for details.

[1]:#Roadmap
[2]:https://github.com/monostable/1clickBOM/blob/master/chrome/data/example.tsv
[3]:https://github.com/monostable/1clickBOM/blob/master/chrome/html/test.html
[4]:http://coffeescript.org
[5]:https://qunitjs.com/
[6]:https://github.com/monostable/1clickBOM/blob/master/LICENSE
[7]:https://github.com/monostable/1clickBOM

