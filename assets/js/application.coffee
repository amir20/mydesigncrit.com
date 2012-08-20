#= require vendor/jquery-1.8.0.min
#= require_tree vendor
#= require_self
#= require_tree .

$.localtime.setFormat("MMMMM dd, yyyy")
jQuery.fn.exists = -> @length > 0
