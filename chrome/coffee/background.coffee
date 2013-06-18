class Retailer
    constructor: (name, country) ->
        @name = name + " " + country

    clearCart: (ref)->
        console.log ref.name + " cart cleared."

class @InvalidCountryError extends Error
    constructor: ->
        @name = "InvalidCountryError"
        @message = "Invalid country-code"


class @Digikey extends Retailer
    constructor: (country_code) ->
        xhr = new XMLHttpRequest()
        xhr.open "GET", chrome.extension.getURL("/data/digikey_international.json"), false
        xhr.send()
        if xhr.status == 200
            data = JSON.parse xhr.responseText
        country = data.lookup[country_code]
        if !country
            error = new InvalidCountryError()
            error.message += " \"" + country_code + "\" given to Digikey."
            throw error
        @site = data.sites[country]
        @cart = data.carts[country]
        super "Digikey", country


    clearCart: ->
        that = this
        if /classic/.test @cart
            #for the classic sites we have to open a tab with with the new order url and actually "click" the button to clear the cart, WTF
            clear_url = "https" + @site + "/classic/Ordering/OrderingHome.aspx"
            chrome.tabs.create {"url":clear_url, "active":false}, (temp_tab)->
                code = "document.forms[1].elements['ctl00_mainContentPlaceHolder_btnCreateNewOrder'].click();"
                chrome.tabs.executeScript temp_tab.id, {"code":code}, ()->
                    done = false
                    #check every 100ms wether cart has been cleared, if yes, close the tab and reload any open cart tabs
                    check_done = setInterval ()->
                        chrome.tabs.get temp_tab.id, (temp_tab_after_execute)->
                            if (new RegExp @cart).test temp_tab_after_execute.url
                                clearInterval check_done
                                chrome.tabs.remove temp_tab_after_execute.id

                                chrome.tabs.query {"url":"*" + that.site + "/classic/*rdering/*dd*art.aspx*"}, (tabs)->
                                    chrome.tabs.reload tab.id for tab in tabs

                                done = true
                                super that
                    , 100

                    #give up after 5s
                    setTimeout ()->
                        if !done
                            console.error that.name + " cart clearing failed."
                            clearInterval check_done
                    , 5000
        else if /ShoppingCartView/.test @cart
            xhr = new XMLHttpRequest
            xhr.open("POST", "https" + @site + @cart + "?explicitNewOrder=Y")
            xhr.onreadystatechange = () ->
                if xhr.readyState == 4
                    console.log that.name + " site cart cleared."
                    chrome.tabs.query {"url":"*" + that.site + that.cart + "*"}, (tabs)->
                        chrome.tabs.reload tab.id for tab in tabs
            xhr.send()
