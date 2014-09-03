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

class window.Farnell extends RetailerInterface
    constructor: (country_code, settings) ->
        super("Farnell", country_code, "/data/farnell_international.json", settings)
        @icon_src = chrome.extension.getURL("images/farnell.ico")

        #export.farnell.com tries to go to exportHome.jsp if we have no cookie
        #and we don't do this
        if @site == "://export.farnell.com"
            fix_url = "http" + @site + @cart + "?_DARGS=/jsp/home/exportHome.jsp_A&_DAV=en_EX_DIRECTEXP"
            fix_xhr = new XMLHttpRequest
            fix_xhr.open("GET", fix_url, false)
            fix_xhr.send()
        else if country_code in ["FI", "DK", "NO", "SE"]
            #these web interfaces are like Newark's so we get all our methods
            #from Newark
            for name, method of Newark::
                this[name] = method
            switch country_code
                when "FI" then @store_id = "10159"
                when "DK" then @store_id = "10157"
                when "NO" then @store_id = "10169"
                when "SE" then @store_id = "10177"

    clearCart: (callback) ->
        @clearing_cart = true
        @_get_item_ids (ids) =>
            @_post_clear(ids, callback)

    _get_item_ids: (callback) ->
        url = "http" + @site + @cart
        get url, (event) =>
            doc = DOM.parse(event.target.responseText)
            ins = doc.getElementsByTagName("input")
            ids = []
            for element in ins
                if element.name == "/pf/commerce/CartHandler.removalCommerceIds"
                    ids.push(element.value)
            callback(ids)
        , () =>
            callback([])


    _post_clear: (ids, callback) ->
        if (ids.length)
            url = "http" + @site + "/jsp/checkout/paymentMethod.jsp"
            txt_1 = ""
            txt_2 = ""
            for id in ids
                txt_1 += "&/pf/commerce/CartHandler.removalCommerceIds=" + id
                txt_2 += "&" + id + "=1"
            params = "/pf/commerce/CartHandler.addItemCount=5&/pf/commerce/CartHandler.addLinesSuccessURL=../shoppingCart/shoppingCart.jsp&/pf/commerce/CartHandler.moveToPurchaseInfoErrorURL=../shoppingCart/shoppingCart.jsp&/pf/commerce/CartHandler.moveToPurchaseInfoSuccessURL=../checkout/paymentMethod.jsp&/pf/commerce/CartHandler.punchOutSuccessURL=orderReviewPunchOut.jsp" + txt_1 + "&/pf/commerce/CartHandler.setOrderErrorURL=../shoppingCart/shoppingCart.jsp&/pf/commerce/CartHandler.setOrderSuccessURL=../shoppingCart/shoppingCart.jsp&_D:/pf/commerce/CartHandler.addItemCount= &_D:/pf/commerce/CartHandler.addLinesSuccessURL= &_D:/pf/commerce/CartHandler.moveToPurchaseInfoErrorURL= &_D:/pf/commerce/CartHandler.moveToPurchaseInfoSuccessURL= &_D:/pf/commerce/CartHandler.punchOutSuccessURL= &_D:/pf/commerce/CartHandler.removalCommerceIds= &_D:/pf/commerce/CartHandler.setOrderErrorURL= &_D:/pf/commerce/CartHandler.setOrderSuccessURL= &_D:Submit= &_D:addEmptyLines= &_D:clearBlankLines= &_D:continueWithShipping= &_D:emptyLinesA= &_D:emptyLinesB= &_D:lineNote= &_D:lineNote= &_D:lineNote= &_D:lineNote= &_D:lineNote= &_D:lineNote= &_D:lineNote1= &_D:lineQuantity= &_D:lineQuantity= &_D:lineQuantity= &_D:lineQuantity= &_D:lineQuantity= &_D:lineQuantity= &_D:reqFromCart= &_D:textfield2= &_D:topUpdateCart= &_DARGS=/jsp/shoppingCart/fragments/shoppingCart/cartContent.jsp.cart&_dyncharset=UTF-8" + txt_2 + "&emptyLinesA=0&emptyLinesB=0&lineNote=&lineNote=&lineNote=&lineNote=&lineNote=&lineNote=&lineNote1=&lineQuantity=1&lineQuantity=1&lineQuantity=1&lineQuantity=1&lineQuantity=1&lineQuantity=1&reqFromCart=true&textfield2=&topUpdateCart=Update Basket"
            post url, params, (event) =>
                if callback?
                    callback({success:true})
                @refreshSiteTabs()
                @refreshCartTabs()
                @clearing_cart = false
            , item={part:"clear cart request", retailer:"Farnell"}, json=false
            , () =>
                if callback?
                    callback({success:false})
                @clearing_cart = false
        else
          if callback?
              callback({success:true})
          @clearing_cart = false

    addItems: (items, callback) ->
        @adding_items = true
        @_add_items items, (result) =>
            if not result.success
                @_add_items_individually items, (result) =>
                    callback(result, this, items)
                    @refreshCartTabs()
                    @refreshSiteTabs()
                    @adding_items = false
            else
                callback(result, this, items)
                @refreshCartTabs()
                @refreshSiteTabs()
                @adding_items = false
    _add_items: (items, callback) ->
        url = "http" + @site + @additem
        result = {success:true, fails:[]}
        params = "dyncharset=UTF-8&%2Fpf%2Fcommerce%2Forder%2FQuickPaste.buySuccessURL=%2Fjsp%2FshoppingCart%2FshoppingCart.jsp&_D%3A%2Fpf%2Fcommerce%2Forder%2FQuickPaste.buySuccessURL=+&%2Fpf%2Fcommerce%2Forder%2FQuickPaste.buyErrorURL=%2Fjsp%2FshoppingCart%2FquickPaste.jsp&_D%3A%2Fpf%2Fcommerce%2Forder%2FQuickPaste.buyErrorURL=+&_D%3AtextBox=+&textBox="
        for item in items
            params += encodeURIComponent(item.part + "," + item.quantity + ",\"" + item.comment + "\"\r\n")
        params += "&%2Fpf%2Fcommerce%2Forder%2FQuickPaste.addPasteProducts=Add+To+Basket&_D%3A%2Fpf%2Fcommerce%2Forder%2FQuickPaste.addPasteProducts=+&submitQuickPaste=Add+To+Basket&_D%3AsubmitQuickPaste=+&_DARGS=%2Fjsp%2FshoppingCart%2Ffragments%2FquickPaste%2FquickPaste.jsp.quickpaste"
        post url, params, (event) =>
            #if items successully add the request returns the basket
            doc = DOM.parse(event.target.responseText)
            #we determine the request has returned the basket by the body
            #classname so it's language agnostic
            result.success = doc.querySelector("body.shoppingCart") != null
            if not result.success
                result.fails = items
            if callback?
                callback(result)
         , item={part:"parts",retailer:"Farnell"}, json=false, () =>
            if callback?
                callback({success:false, fails:items})

    _add_items_individually: (items, callback) ->
        result = {success:true, fails:[]}
        count = items.length
        for item in items
            @_add_items [item], (r) =>
                result.success &&= r.success
                result.fails = result.fails.concat(r.fails)
                count--
                if count == 0
                    if callback?
                        callback(result)
