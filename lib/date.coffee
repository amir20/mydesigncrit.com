Date::toUTCArray = ->
  D = this
  [ D.getUTCFullYear(), D.getUTCMonth(), D.getUTCDate(), D.getUTCHours(), D.getUTCMinutes(), D.getUTCSeconds() ]

Date::toISO = ->
  tem = undefined
  A = @toUTCArray()
  i = 0
  A[1] += 1
  while i++ < 7
    tem = A[i]
    A[i] = "0" + tem  if tem < 10
  A.splice(0, 3).join("-") + "T" + A.join(":")