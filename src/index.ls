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
    @rbox = @_rebox(@_r.getBoundingClientRect!)

    Array.from(@_r.querySelectorAll('[data-type=layout] .pdl-cell[data-name]')).map (node,i) ~>
      name = node.getAttribute \data-name
      @node[name] = node
      @box[name] = box = @_rebox(node.getBoundingClientRect!)

      box.x -= @rbox.x
      box.y -= @rbox.y
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
    rbox = @_rebox(@_r.getBoundingClientRect!)
    box = @_rebox(@get-node(n).getBoundingClientRect!)
    box.x -= rbox.x
    box.y -= rbox.y
    return box
  get-node: -> @node[it]
  get-group: -> @group[it]
  get-nodes: -> {} <<< @node
  get-groups: -> {} <<< @group

if window? => window.layout = layout
if module? => module.exports = layout
