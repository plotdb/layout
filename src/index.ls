svgns = "http://www.w3.org/2000/svg"

layout = (opt={}) ->
  @_r = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
  @opt = {auto-svg: true, round: true} <<< opt
  if !(@opt.watch-resize?) => @opt.watch-resize = true
  @evt-handler = {}
  @box = {}
  @node = {}
  @group = {}
  @

resizeObserver = do
  wm: new WeakMap!
  ro: new ResizeObserver (list) ->
    list.map (n) ->
      ret = resizeObserver.wm.get(n.target)
      ret.update!
  add: (node, obj) ->
    @wm.set node, obj
    @ro.observe node
  delete: ->
    @ro.unobserve it
    @wm.delete it

layout.prototype = Object.create(Object.prototype) <<< do
  on: (n, cb) -> @evt-handler.[][n].push cb
  fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v
  init: (cb) ->
    <~ Promise.resolve!then _
    if @opt.watch-resize => resizeObserver.add @_r, @
    if (!(@opt.auto-svg?) or @opt.auto-svg) =>
      svg = @_r.querySelector('[data-type=render] > svg')
      if !svg =>
        svg = document.createElementNS(svgns, "svg")
        svg.setAttribute \width, \100%
        svg.setAttribute \height, \100%
        @_r.querySelector('[data-type=render]').appendChild svg
      Array.from(@_r.querySelectorAll('[data-type=layout] .pdl-cell[data-name]')).map (node,i) ~>
        name = node.getAttribute \data-name
        @node[name] = node
        if node.hasAttribute \data-only => return
        g = @_r.querySelector("g.pdl-cell[data-name=#{name}]")
        if !g =>
          g = document.createElementNS(svgns, "g")
          svg.appendChild g
          g.classList.add \pdl-cell
          g.setAttribute \data-name, name
        @group[name] = g

    ret = cb.apply @
    if ret and typeof(ret.then) == \function => ret.then(~>@update!) else @update!
  destroy: -> resizeObserver.delete @_r
  # box of `node` relative to root, in root's own ( untransformed ) coordinate.
  #
  # getBoundingClientRect returns the *visual* box, so an ancestor transform such as
  # `transform: scale(k)` scales it by k - using it as svg coordinate then applies k twice.
  # offsetWidth / offsetHeight are layout sizes not affected by ancestor transforms,
  # so we derive the scale factor of root from their ratio and divide it out.
  # ( offset* are integers; ignore difference under 1px to avoid introducing error. )
  _measure: (node) ->
    rr = @_r.getBoundingClientRect!
    [ow, oh] = [@_r.offsetWidth, @_r.offsetHeight]
    sx = if ow and Math.abs(rr.width - ow) >= 1 => rr.width / ow else 1
    sy = if oh and Math.abs(rr.height - oh) >= 1 => rr.height / oh else 1
    rbox = {x: 0, y: 0, width: rr.width / sx, height: rr.height / sy}
    if !node => return rbox
    b = node.getBoundingClientRect!
    return {x: (b.x - rr.x) / sx, y: (b.y - rr.y) / sy, width: b.width / sx, height: b.height / sy}

  _rebox: (b) ->
    if !@opt.round => return b
    ret = {}
    ret.x = Math.round(b.x)
    ret.width = Math.round(b.x + b.width) - ret.x
    ret.y = Math.round(b.y)
    ret.height = Math.round(b.y + b.height) - ret.y
    return ret

  # opt: fire rendering event if opt is true or undefined.
  update: (opt) ->
    if !@_r => return
    if !(opt?) or opt => @fire \update
    @rbox = @_rebox(@_measure!)

    Array.from(@_r.querySelectorAll('[data-type=layout] .pdl-cell[data-name]')).map (node,i) ~>
      name = node.getAttribute \data-name
      @node[name] = node
      @box[name] = box = @_rebox(@_measure node)
      if node.hasAttribute \data-only => return
      @group[name] = g = @_r.querySelector("g.pdl-cell[data-name=#{name}]")
      g.setAttribute \transform, "translate(#{Math.round(box.x)},#{Math.round(box.y)})"
      g.layout = {node, box}
    if !(opt?) or opt => @fire \render
  root: -> @_r
  get-box: (n, cached = false) ->
    # from cached value:
    if cached => return @box[n]
    # or realtime value:
    return @_rebox(@_measure @get-node(n))
  get-node: -> @node[it]
  get-group: -> @group[it]
  get-nodes: -> {} <<< @node
  get-groups: -> {} <<< @group

if module? => module.exports = layout
else if window? => window.layout = layout
