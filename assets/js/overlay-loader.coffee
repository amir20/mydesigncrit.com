opts =
  lines: 17
  length: 0
  width: 10
  radius: 40
  corners: 1
  rotate: 0
  color: '#fff'
  speed: 1.3
  trail: 87
  shadow: true
  hwaccel: true
  className: 'spinner'
  zIndex: 2e9
  top: 'auto'
  left: 'auto'

window.showLoader = -> $('<div />', id: 'loader', class: 'overlay').appendTo(document.body).spin(opts)
window.removeLoader = -> $('#loader.overlay').remove()