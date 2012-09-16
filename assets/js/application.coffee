#= require vendor/jquery-1.8.0.min
#= require_tree vendor
#= require_self
#= require_tree .

$.localtime.setFormat("MMMMM dd, yyyy")

jQuery.fn.exists = -> @length > 0
  
$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] isnt `undefined`
      o[@name] = [ o[@name] ]  unless o[@name].push
      o[@name].push @value or ""
    else
      o[@name] = @value or ""

  return o

$ -> 
  $('.popbox').popbox
   open: '.open'
   arrow: '.popbox-arrow'
   close: '.popbox-close'
  ($ 'img.retina').retina()
