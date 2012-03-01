$ ->
  ($ document).mousemove (e) -> 
    [$doc, $win] = [($ document), ($ window)]
    [x, y, width, height] = [e.pageX - $doc.scrollLeft(), e.pageY - $doc.scrollTop(), $win.width(), $win.height()]
    
    ($ '.grid.top.left').css width: x, height: y
    ($ '.grid.top.right').css width: width - x, height: y    
    ($ '.grid.bottom.left').css width: x, height: height - y      
    ($ '.grid.bottom.right').css width: width - x, height: height - y  