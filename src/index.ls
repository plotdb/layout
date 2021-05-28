svgns = "http://www.w3.org/2000/svg"

layout = (opt={}) ->
  @root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
  @opt = {auto-svg: true} <<< opt
  @evt-handler = {}
  @box = {}
  @node = {}
  @group = {}
  @

layout.prototype = Object.create(Object.prototype) <<< do
  on: (n, cb) -> @evt-handler.[][n].push cb
  fire: (n, ...v) -> for cb in (@evt-handler[n] or []) => cb.apply @, v
  init: (cb) ->
    <~ Promise.resolve!then _
    window.addEventListener \resize, ~> @update!
    if (!(@opt.auto-svg?) or @opt.auto-svg) =>
      svg = @root.querySelector('[data-type=render] > svg')
      if !svg =>
        svg = document.createElementNS(svgns, "svg")
        svg.setAttribute \width, \100%
        svg.setAttribute \height, \100%
        @root.querySelector('[data-type=render]').appendChild svg
      Array.from(@root.querySelectorAll('[data-type=layout] .pdl-cell[data-name]')).map (node,i) ~>
        name = node.getAttribute \data-name
        if (g = @root.querySelector("g.pdl-cell[data-name=#{name}]")) => return
        g = document.createElementNS(svgns, "g")
        svg.appendChild g
        g.classList.add \pdl-cell
        g.setAttribute \data-name, name

    cb.apply @
    @update!
  update: ->
    if !@root => return
    @rbox = @root.getBoundingClientRect!
    Array.from(@root.querySelectorAll('[data-type=layout] .pdl-cell[data-name]')).map (node,i) ~>
      name = node.getAttribute \data-name
      @node[name] = node
      @box[name] = box = node.getBoundingClientRect!{x,y,width,height}
      box.x -= @rbox.x
      box.y -= @rbox.y
      @group[name] = g = @root.querySelector("g.pdl-cell[data-name=#{name}]")
      g.setAttribute \transform, "translate(#{box.x},#{box.y})"
      g.layout = {node, box}
    @fire \render
  get-box: -> @box[it]
  get-node: -> @node[it]
  get-group: -> @group[it]

if window? => window.layout = layout
if module? => module.exports = layout
