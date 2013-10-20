calculateMean = (a) ->
  sum = 0

  for e in a
    sum += e

  sum / a.length

window.calculateVariance = (a) ->
  temp = 0
  mean = calculateMean(a)

  for e in a
    temp += Math.pow(mean - e, 2)

  temp / a.length

calculateStdDev = (a) ->
  Math.sqrt calculateVariance(a)

initIcons = (iconClass) ->
  ICONS = ["home", "glass", "star", "male", "female", "bug"]
  window.bench = {}
  window.bench.icons = []
  window.bench.iconsHTML = []

  for i in [0..6]
    window.bench.icons.push document.getElementById("test_#{i}")
    window.bench.iconsHTML.push "<i class=\"#{iconClass}-#{ICONS[i]}\"></i>"
  return

setIcons = (iconClass, start) ->
  for i in [0..6]
    window.bench.icons[(i + start) % 6].innerHTML = window.bench.iconsHTML[i]
  return

attachEvent = (element) ->
  if element.addEventListener?
    element.addEventListener 'click', launchTest, false
  else if element.attachEvent?
    element.attachEvent 'onclick', launchTest

launchTest = ->
  document.getElementById('startTest').setAttribute('disabled', 'disabled')
  document.getElementById('results').innerHTML = '<span class="text-warning">Please wait...</span>'
  setTimeout ->
    test()
  , 100
  return

finishTest = (results) ->
  document.getElementById('results').innerHTML = "<b class=\"text-success\">DONE!</b> Average: <b>#{calculateMean(results).toFixed(2)}ms</b> <span class=\"text-muted\">[Standard Deviation: <b>#{calculateStdDev(results).toFixed(2)}ms</b>]</span>"
  document.getElementById('startTest').removeAttribute 'disabled'
  return

test = ->
  loops = document.getElementById('loops').value
  results = []
  bodyElement = document.getElementById('body')
  iconClass = bodyElement.getAttribute('data-icon-class')
  initIcons iconClass

  for l in [0...loops]
    start = new Date().getTime()

    for i in [0...100]
      setIcons iconClass, i % 6
      forceRendering = bodyElement.offsetWidth + bodyElement.offsetHeight
    stop = new Date().getTime()
    results.push stop - start

  finishTest results
  return

init = ->
  attachEvent document.getElementById('startTest')

if window.addEventListener?
  window.addEventListener 'load', init, false
else if window.attachEvent?
  window.attachEvent 'onload', init
else
  document.addEventListener 'load', init, false
