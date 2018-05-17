export default (bits, abc)->
  throw Error "記号が足りません" if abc.length < (1 << bits)
  size = abc.length
  decode = {}
  encode = abc

  for c, n in abc
    decode[c] = n

  toHex: (code)->
    str = ""
    base = 1
    buffer = 0

    bits = 4
    limit = 1 << bits
    mask = limit - 1
    for c in code by -1
      n = decode[c]
      unless n?
        console.error "decode error on #{c}"
        return null

      buffer += n * base
      base *= size

      while base >= limit
        str = (buffer & mask).toString(16) + str
        buffer >>= bits
        base >>= bits
    str

  byNumber: (size, buffer)->
    mask = (1 << bits) - 1

    str = ""
    for index in [size * 8 .. 0] by -bits
      n = index - bits

      switch
        when n > 31 - bits
          code = 0
#          console.warn [n]
        when n > 0
          code = (buffer & (mask <<  n)) >>  n
#          console.warn [n, [ buffer, (mask << n), code].map (it)-> it.toString(2)]
        when n == 0
          code = buffer & mask
#          console.warn [n, [ buffer, mask, code].map (it)-> it.toString(2)]
        when 0 > n
          code = (buffer & (mask >> -n)) << -n
#          console.warn [n, [ buffer, (mask >> -n), code].map (it)-> it.toString(2)]

      str += encode[code]
    str
