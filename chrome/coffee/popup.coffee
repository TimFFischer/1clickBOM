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

show_or_hide_buttons = (bom) ->
    if (!bom)
        bom = {}
    document.querySelector("#clear").hidden=!Boolean(Object.keys(bom).length)
    document.querySelector("#fill_carts").hidden=!Boolean(Object.keys(bom).length)
    document.querySelector("#empty_carts").hidden=!Boolean(Object.keys(bom).length)
    document.querySelector("#open_cart_tabs").hidden=!Boolean(Object.keys(bom).length)
    document.querySelector("#bom").hidden=!Boolean(Object.keys(bom).length)

rebuild_bom_view = (bom) ->
    table = document.querySelector("#bom_list")
    table.removeChild(table.lastChild) while table.hasChildNodes()
    for retailer_name of bom
        retailer = bom[retailer_name].interface
        items    = bom[retailer_name].items
        no_of_items = 0
        for item in items
            no_of_items += item.quantity
        tr = document.createElement("tr")
        td_0 = document.createElement("td")

        icon = document.createElement("img")
        icon.src = retailer.icon_src
        td_0.appendChild(icon)
        td_0.innerHTML += retailer.interface_name
        tr.appendChild(td_0)

        td_1 = document.createElement("td")
        td_1.innerText = items.length + " line"
        td_1.innerText += "s" if (items.length > 1)
        tr.appendChild(td_1)

        td_2 = document.createElement("td")
        td_2.innerText = no_of_items + " item"
        td_2.innerText += "s" if (no_of_items > 1)
        tr.appendChild(td_2)
        td = document.createElement("td")

        unicode_chars = ["\uf21e", "\uf221", "\uf21b"]
        titles = ["Add items to " , "View ",  "Empty "]
        links = []
        for i in  [0..2]
            td = document.createElement("td")
            a = document.createElement("a")
            a.value = retailer_name
            a.title = titles[i] + retailer_name + " cart"
            a.href = "#"
            links.push(a)
            span = document.createElement("span")
            span.className = "button_icon"
            span.innerText = unicode_chars[i]
            a.appendChild(span)
            td.appendChild(a)
            tr.appendChild(td)

        links[0].addEventListener "click", () ->
            td = this.parentNode
            counter = 0
            spin = document.createElement("div")
            spin.className = "spinner"
            td.appendChild(spin)
            id = setInterval ()->
                frames=12; frameWidth = 15;
                offset=counter * -frameWidth;
                spin.style.backgroundPosition=
                    offset + "px" + " " + 0 + "px";
                counter++
                if (counter>=frames)
                    counter =0;
            , 50
            td.querySelector("a").hidden=true
            window.bom_manager.fillCart(@value)

        links[1].addEventListener "click", () ->
            window.bom_manager.openCart(@value)

        links[2].addEventListener "click", () ->
            window.bom_manager.emptyCart(@value)

        table.appendChild(tr)

bom_changed = () ->
    bom = window.bom_manager.getBOM()
    show_or_hide_buttons(bom)
    rebuild_bom_view(bom)

window.bom_manager = new BomManager () ->
    bom_changed()
    
chrome.storage.onChanged.addListener (changes, namespace) ->
    if namespace == "local"
        if changes.bom || changes.country || changes.settings
            window.bom_manager = new BomManager () ->
                bom_changed()
    
chrome.runtime.getBackgroundPage (bkgd_page) ->
    document.querySelector("#paste").addEventListener "click", ()->
        bkgd_page.paste (text) ->
            window.bom_manager.addToBOM(text)

    #Ctrl-V event
    document.addEventListener 'keydown', (event) ->
        if ((event.keyCode == 86) && (event.ctrlKey == true))
            text = bkgd_page.paste()
            window.bom_manager.addToBOM(text)

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
    if(request.invalid)
        console.log(request.invalid)

document.querySelector("#clear").addEventListener "click", () ->
    chrome.storage.local.remove("bom")
    clear_warning_log()
document.querySelector("#fill_carts").addEventListener "click", () ->
    window.bom_manager.fillCarts()
document.querySelector("#empty_carts").addEventListener "click", () ->
    window.bom_manager.emptyCarts()
document.querySelector("#open_cart_tabs").addEventListener "click", () ->
    window.bom_manager.openCarts()
