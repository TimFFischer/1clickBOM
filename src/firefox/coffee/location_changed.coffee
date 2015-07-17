tabs       = require 'sdk/tabs'
{viewFor}  = require 'sdk/view/core'
{modelFor} = require 'sdk/model/core'
{Ci, Cu}   = require 'chrome'
{getBrowserForTab, getTabForContentWindow} = require 'sdk/tabs/utils'
Cu.import('resource://gre/modules/XPCOMUtils.jsm', this)

listeners = []
progressListener =
    QueryInterface: XPCOMUtils.generateQI([Ci.nsIWebProgressListener, Ci.nsISupportsWeakReference])
    onLocationChange: (aProgress, aRequest, aURI) ->
        highLevelTab = modelFor(getTabForContentWindow(aProgress.DOMWindow))
        for callback in listeners
            callback(highLevelTab)

attach = (tab) ->
    lowLevelTab = viewFor(tab)
    browser     = getBrowserForTab(lowLevelTab)
    browser.addProgressListener(progressListener)

tabs.on 'open', attach

exports.on = (callback) ->
    listeners.push(callback)

exports.attach = attach
