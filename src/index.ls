layout = (opt={}) ->
  @root = if typeof(opt.root) == \string => document.querySelector(opt.root) else opt.root
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
    cb.apply @
    @update!
  update: ->
    @rbox = @root.getBoundingClientRect!
    Array.from(@root.querySelectorAll('[data-type=layout] .cell[data-name]')).map (node,i) ~>
      name = node.getAttribute \data-name
      @node[name] = node
      @box[name] = box = node.getBoundingClientRect!{x,y,width,height}
      box.x -= @rbox.x
      box.y -= @rbox.y
      @group[name] = g = @root.querySelector("g.#{name}")
      g.setAttribute \transform, "translate(#{box.x},#{box.y})"
      g.layout = {node, box}
    @fire \render
  get-box: -> @box[it]
  get-node: -> @node[it]
  get-group: -> @group[it]

if window? => window.layout = layout
