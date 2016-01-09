
[![Youtube Demo][22]](https://youtu.be/611TW315pZM)

[![Available on Chrome][8]][14] [![Add to Firefox][9]][13]


## Summary ##

1-click BOM is a browser extension that fills your shopping carts for you on
sites like Digikey and Mouser, you simply paste from a spreadsheet or visit an
online `.tsv` file. This way you can keep one bill of materials (BOM) that lets
you and people you share the BOM with quickly purchase items from multiple
retailers.

## Table of Contents ##

* [Summary](#summary)
* [News](#news)
* [Which retailers?](#which-retailers)
* [Usage](#usage)
* [Issues](#issues)
* [Roadmap](#roadmap)
* [Development](#development)
* [License](#license)

## News ##

- [Added function to auto-complete BOM](#completion)

- [Named columns are now supported](#usage)

- [1clickBOM is available for Firefox][20]

- [I gave a talk about 1clickBOM at FOSDEM in 2015][12]

## Which retailers? ##

Currently supported retailers are:

* Digikey
* Mouser
* Farnell/Element14
* Newark
* RS

Check the [roadmap](#roadmap) for more details on planned features.

## Usage ##

### Adding Items ###

In your tab-seperated values (`.tsv`) or spreadsheet you must have a column for
line-note, one for the quantity and at least one retailer. Column titles are
interpreted in the following way by 1clickBOM. Capitalisation is ignored.

    reference                : References
    references               : References
    line-note                : References
    line note                : References
    comment                  : Description
    comments                 : Description
    cmnts                    : Description
    description              : Description
    descr.                   : Description
    qty                      : Quantity
    quantity                 : Quantity
    part-number              : Part Number
    partnumber               : Part Number
    part number              : Part Number
    m/f part                 : Part Number
    manuf. part              : Part Number
    mpn                      : Part Number
    m/f part number          : Part Number
    manuf. part number       : Part Number
    manufacturer part        : Part Number
    manufacturer part number : Part Number
    manufacturer             : Manufacturer
    m/f                      : Manufacturer

If you visit a page that ends in `.tsv` and has data in the right format
available 1clickBOM will show a blue badge and button with an arrow. Clicking
the blue button will load the data into 1clickBOM.  Alternatively you can paste
from any spreadsheet (Excel, OpenOffice, LibreOffice, etc.) by selecting the
relevant columns copying them and then clicking the paste button on 1clickBOM's
popup.

![Load from page][3]

See the [example tsv][2] and the [Bus Pirate tsv][21].

### Let's go shopping! ###

Once the data is added you can use 1clickBOM to add the items to your carts
using the buttons on the popup. You can also quickly view and empty your carts.

### Completion ###

New in version 0.5 is a function to search Octopart.com and Findchips.com to try
and complete a BOM for you. A complete BOM is one that has a part number for
_every_ retailer. Simply press the button labeled 'Complete' and 1clickBOM will
use other fields to search for the fields that are left blank.

### Legacy BOM format ###

The format used prior to version `0.3` simply had the items in the following order:

    line-note | quantity | retailer | part-number

This format is still supported but deprecated and will be phased out by version
`1.0`.

## Issues ##

If you need any help or think you found a bug please get in touch via
[GitHub][10] or [email][11].

## Roadmap ##

* 0.6
    * Add retailer preference ranking
    * Add function to reduce BOM (and add to cart?) according to retailer preference

* 1.0
    * Support for direct loading from Google docs pages
    * Add buttons to pages with BOM data
    * Remove legacy BOM format support

* 2.0
    * BOM details and editing page
    * Display cart summaries
    * Allied, Arrow, AVNet, Conrad and Rapid
    * Function to minimize order cost + shipping
    * Allow adding components to BOM from the component page

* 3.0
    * 3D-chip-printer support

* 4.0
    * Communicate through quantum entanglement

## Development ##

### Build and Test Requirements ###

The code is available on [GitHub][7]. To get started you will need:

- Chrome or Chromium
- Firefox (optionally with [Extension Autoinstaller][16])
- [Mozilla Add-on SDK][18] (cfx)
- GNU Make
- sed
- npm

The rest of the dependencies can be retrieved via `npm install`.

### Build and Test Instructions ###

#### Build

- Get dependencies above and make sure executables are on your path
- `npm install --global` (or `npm install && export PATH=$PATH:$(pwd)/node_modules/.bin`)
- `make`

#### Load

- For Chrome enable developer mode in `chrome://extensions` and load the unpacked extension from `build/chrome`
- For Firefox run `make run-firefox` (or setup [Autoinstaller][16] and run `make load-firefox`)

#### Test

Tests are written in [QUnit 1.11][17] and can only be run in Chrome/Chromium.
Open a console on background page and execute `Test()` or test a specific
module, e.g.  Farnell, with `Test('Farnell')`

Most of the tests are functional tests that require interaction with the
various retailer sites and they make a lot of network requests to test across
all the different possible locations. Sometimes they will fail because they are
not an accurate representation of actual extension use. If a test fails or
doesn't complete, run it again before investigating. Try and re-create the
issue manually before trying to fix it.

## License ##

1clickBOM is free and open source software. It is licensed under a CPAL license
which means you are free to use the code in your own applications (even
proprietary ones) as long as you display appropriate attribution and share your
code-improvements to 1clickBOM itself under the CPAL as well. This also applies
to software you are solely making available to users over a network i.e.
software as a service. See the [LICENSE][6] file for details.

[2]:https://github.com/monostable/1clickBOM/blob/master/examples/example.tsv
[3]:https://raw.githubusercontent.com/monostable/1clickBOM/master/readme_images/load_from_page.png
[4]:http://coffeescript.org
[5]:https://qunitjs.com/
[6]:https://github.com/monostable/1clickBOM/blob/master/LICENSE
[7]:https://github.com/monostable/1clickBOM
[8]:https://raw.githubusercontent.com/monostable/1clickBOM/master/readme_images/chrome.png
[9]:https://raw.githubusercontent.com/monostable/1clickBOM/master/readme_images/firefox.png
[10]:https://github.com/monostable/1clickBOM/issues
[11]:mailto:info@1clickBOM.com
[12]:http://video.fosdem.org/2015/devroom-electronic_design_automation/one_click_bom.mp4
[13]:https://addons.mozilla.org/firefox/downloads/latest/634060/addon-634060-latest.xpi
[14]:https://chrome.google.com/webstore/detail/1clickbom/mflpmlediakefinapghmabapjeippfdi
[15]:https://raw.githubusercontent.com/monostable/1clickBOM/master/readme_images/demo.gif
[16]:https://palant.de/2012/01/13/extension-auto-installer
[17]:https://web.archive.org/web/20130128010139/http://api.qunitjs.com/
[18]:https://developer.mozilla.org/en-US/Add-ons/SDK
[19]:http://1clickBOM.com
[20]:https://addons.mozilla.org/en-US/firefox/addon/1clickbom/
[21]:https://github.com/monostable/1clickBOM/blob/master/examples/bus_pirate.tsv
[22]:https://github.com/monostable/1clickBOM/blob/feat-auto-complete/readme_images/youtube.png


