@Test = ()->
    url = chrome.extension.getURL("html/test.html")
    window.open(url)

@UserSim = ()->
    url = chrome.extension.getURL("html/test_user_simulation.html")
    window.open(url)

@LongTest = ()->
    url = chrome.extension.getURL("html/test_long.html")
    window.open(url)
