

[![Available on Chrome][8]][14] [![Add to Firefox][9]][13]

1-click BOM is a browser extension that fills your shopping carts for you on
sites like Digikey and Mouser, you simply paste from a spreadsheet or visit an
online `.tsv` file. This way you can keep one bill of materials (BOM) that lets
you and people you share the BOM with quickly purchase items from multiple
retailers.

## News ##

#### - [1clickBOM is now available for Firefox][13]

#### - [I gave a talk about 1clickBOM at FOSDEM][12]

## Which retailers? ##

Currently supported retailers are:

* Digikey
* Mouser
* Farnell/Element14
* Newark
* RS

Check the [roadmap][1] for more details on planned features.

## Usage ##

### Adding Items ###

You should arrange items in your spreadsheet in the following order.

    line-note | quantity | retailer | part-number

Line-note can be anything you like. I normally use schematic references.
Retailer is a name of one of the supported retailers and part-number is the
part-number specific to that retailer. See the [example tsv][2].

In your spreadsheet select the relevant columns, copy and then click the paste
button on the 1clickBOM popup.

![Load from page][3]

Alternatively, if you visit a page that ends in `.tsv` and has data in the
right format available 1clickBOM will show a blue badge and button with an
arrow. Press the blue button in the popup and the data will be added. You can
try this on the [example tsv page][2] once you have the extension installed.

### Let's go shopping! ###

Once the data is added you can use 1clickBOM to add the items to your carts
using the buttons on the popup. You can also quickly view and empty your carts.

## Issues ##

If you need any help or think you found a bug please get in touch via
[GitHub][10] or [email][11].

## Roadmap ##

* 1.0
    * Multiple retailers per item
    * Named columns
    * Preferred retailer setting
    * Display cart status
    * Paste directly to cart
    * 1clickBOM site interaction

* 2.0
    * Allied, Arrow, AVNet, Conrad and Rapid
    * Function to minimize order cost + shipping
    * Autofind same items from different vendors
    * Display cart summaries
    * Allow adding components to BOM from the component page
    * Export BOM

* 3.0
    * 3D-chip-printer support

* 4.0
    * Communicate through quantum entanglement

## Development ##

### Build and Test Requirements ###

The code is available on [GitHub][7] to get started you will need:

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
- `npm install --global` (or `npm install && export PATH=$PATH:$(pwd)/node_modules/.bin)`
- `make` which builds everything or you can be more specific like `make chrome` or `make firefox` or even `make run-firefox` to build and load in firefox in one step

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
to software you are making available to users as a network service from a
server. See the [LICENSE][6] file for details.

[1]:#roadmap
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
[13]:https://addons.mozilla.org/firefox/downloads/file/330582/1clickbom-0.2.0-fx.xpi
[14]:https://chrome.google.com/webstore/detail/1clickbom/mflpmlediakefinapghmabapjeippfdi
[15]:https://raw.githubusercontent.com/monostable/1clickBOM/master/readme_images/demo.gif
[16]:https://palant.de/2012/01/13/extension-auto-installer
[17]:https://web.archive.org/web/20130128010139/http://api.qunitjs.com/
[18]:https://developer.mozilla.org/en-US/Add-ons/SDK
