$ ->
  ($ document).mousemove (e) -> 
    $doc = ($ document)
    [left, top] = [e.pageX - $doc.scrollLeft(), e.pageY - $doc.scrollTop()]    
    ($ '.gridline.h').css top: top
    ($ '.gridline.v').css left: left
