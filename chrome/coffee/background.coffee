# This file is part of 1clickBOM.
#
# 1clickBOM is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version 3
# as published by the Free Software Foundation.
#
# 1clickBOM is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with 1clickBOM.  If not, see <http://www.gnu.org/licenses/>.

countries_data = @get_local("/data/countries.json")
settings_data  = @get_local("/data/settings.json")

newInterface = (retailer_name, retailer, country, settings) ->
    switch (retailer_name)
        when "Digikey"
            retailer.interface = new   Digikey(country, settings)
        when "Farnell"
            retailer.interface = new Farnell(country, settings)
        when "Mouser"
            retailer.interface = new    Mouser(country, settings)

paste = () ->
    textarea = document.getElementById("pastebox")
    textarea.select()
    document.execCommand("paste")
    result = textarea.value
    return result

parseTSV = (text) ->
    #TODO safety
    rows = text.split "\n"
    items = []
    invalid = []
    for row, i in rows
        if row != ""
            cells = row.split "\t"
            item = {"cells":cells, "comment":cells[0], "quantity":cells[1], "retailer":cells[2],"part":cells[3], "row":i}
            if !item.quantity
                invalid.push {"item":item, "reason": "Quantity is undefined."}
            else if !item.retailer
                invalid.push {"item":item, "reason": "Retailer is undefined."}
            else if !item.part
                invalid.push {"item":item, "reason": "Part number is undefined."}
            else
                items.push item
    return {items, invalid}



checkValidItems = (items_incoming, invalid) ->
    @retailer_aliases = {
        "Farnell"   : "Farnell",
        "Element14" : "Farnell",
        "FEC"       : "Farnell",
        "Premier"   : "Farnell",
        "Digikey"   : "Digikey",
        "Digi-key"  : "Digikey",
        "Mouser"    : "Mouser"
    }
    items = []
    for item in items_incoming
        reasons = []
        number = parseInt(item.quantity)
        if number == NaN
            invalid.push {"item":item, "reason": "Quantity is not a number."}
        else
            item.quantity = number
            r = ""
            #a case insensitive match to the aliases
            for key of @retailer_aliases
                re = new RegExp key, "i"
                if item.retailer.match(re)
                    r = retailer_aliases[key]
                    break

            if  r == ""
                invalid.push({"item":item, "reason": "Retailer \"" + item.retailer + "\" is not known."})
            else
                item.retailer = r
                items.push(item)
    return {items, invalid}

@paste_action = ()->
    chrome.storage.local.get ["bom", "country"], (obj) ->

        bom = obj.bom
        country = obj.country

        if (!bom)
            bom = {}

        if (!country)
            country = "Other"

        text = paste()
        {items, invalid} = parseTSV(text)
        {items, invalid} = checkValidItems(items, invalid)

        if invalid.length > 0
            chrome.runtime.sendMessage({invalid:invalid})

        for item in items
            #if item.retailer not in bom
            found = false
            for key of bom
                if item.retailer == key
                    found = true
                    break
            if (!found)
                bom[item.retailer] = {"items":[]}
            if(!found or (bom[item.retailer].interface.country != country))
                newInterface(item.retailer, bom[item.retailer], country)
            bom[item.retailer].items.push(item)

        chrome.storage.local.set {"bom":bom}

chrome.storage.onChanged.addListener (changes, namespace) ->
    if (namespace == "local" && changes.country)
        chrome.storage.local.get "bom", (obj) ->
            bom = obj.bom
            if (bom)
                for retailer_name, retailer of bom
                    if retailer.interface.country != changes.country.newValue
                        newInterface(retailer_name, retailer, changes.country.newValue)
                chrome.storage.local.set({bom:bom})

lookup_setting_values = (country, retailer, stored_settings)->
    if(stored_settings? && stored_settings[country]? && stored_settings[country][retailer]?)
        settings = settings_data[country][retailer].choices[stored_settings[country][retailer]]
    else
        settings = {}
    return settings


@fill_carts = ()->
    chrome.storage.local.get ["bom", "country", "settings"], ({bom:bom, country:country, settings:stored_settings}) ->
        for retailer of bom
            setting_values = lookup_setting_values(country, retailer, stored_settings)
            newInterface(retailer, bom[retailer], country, setting_values)
            bom[retailer].interface.addItems(bom[retailer].items)

@fill_cart = (retailer)->
    chrome.storage.local.get ["bom", "country", "settings"], ({bom:bom, country:country, settings:stored_settings}) ->

        setting_values = lookup_setting_values(country, retailer, stored_settings)
        newInterface(retailer, bom[retailer], country, setting_values)
        bom[retailer].interface.addItems(bom[retailer].items)

@empty_carts = ()->
    chrome.storage.local.get ["bom", "country", "settings"], ({bom:bom, country:country, settings:stored_settings}) ->
        for retailer of bom
            setting_values = lookup_setting_values(country, retailer, stored_settings)
            newInterface(retailer, bom[retailer], country, setting_values)
            bom[retailer].interface.clearCart()

@empty_cart = (retailer)->
    chrome.storage.local.get ["bom", "country", "settings"], ({bom:bom, country:country, settings:stored_settings}) ->

        setting_values = lookup_setting_values(country, retailer, stored_settings)
        newInterface(retailer, bom[retailer], country, setting_values)
        bom[retailer].interface.clearCart()

@open_cart_tabs = ()->
    chrome.storage.local.get ["bom", "country", "settings"], ({bom:bom, country:country, settings:stored_settings}) ->
        for retailer of bom
            setting_values = lookup_setting_values(country, retailer, stored_settings)
            newInterface(retailer, bom[retailer], country, setting_values)
            bom[retailer].interface.openCartTab()




@get_location = ()->
    xhr = new XMLHttpRequest
    xhr.open "GET", "https://freegeoip.net/json/", true
    xhr.onreadystatechange = (data) ->
        if xhr.readyState == 4 and xhr.status == 200
                response = JSON.parse(xhr.responseText)
                chrome.storage.local.set {country: countries_data[response.country_name]}, ()->
                    chrome.tabs.create({"url": chrome.runtime.getURL("html/options.html")})
    xhr.send()

chrome.runtime.onInstalled.addListener (details)->
    switch details.reason
        when "install", "upgrade"
            @get_location()

#@bom = new Object
#@get_bom = ()->
#    chrome.storage.local.get ["bom"], (obj) ->
#        that.bom = obj.bom
#
#@get_settings = ()->
#    chrome.storage.local.get ["settings"], (obj) ->
#        document.settings = obj.settings

