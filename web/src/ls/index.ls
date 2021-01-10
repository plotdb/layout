data = [0 to 20].map -> Math.round(Math.random! * 100)

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
    Array.from(@root.querySelectorAll('.chart-layout .cell[name]')).map (node,i) ~>
      name = node.getAttribute \name
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

ml = new layout root: '.chart'
ml.on \render, ->
  box = @get-box('view')
  @{}lc.{}scale.y = d3.scaleLinear!
    .range [box.height,0]
    .domain [0, Math.max.apply(Math, data)]
  @lc.scale.x = d3.scaleBand!
    .range [0, box.width]
    .domain [0 to 20]
  d3.select @get-group \xaxis .call d3.axis-bottom(@lc.scale.x)
  d3.select @get-group \yaxis
    .attr \transform, -> "translate(#{@layout.box.width + @layout.box.x},0)"
    .call d3.axis-Left(@lc.scale.y)
  @lc.view.render!

ml.init ->
  @{}lc.view = new ldView do
    root: ld$.find 'g.view', 0
    init-render: false
    handler: data:
      list: -> data
      handler: ({node, data, idx}) ~>
        bw = @lc.scale.x.bandwidth!
        scale = @lc.scale
        attrs = do
          x: scale.x(idx) + 1
          y: scale.y(data)
          width: scale.x.bandwidth! - 2
          height: scale.y(0) - scale.y(data)
        for k,v of attrs => node.setAttribute k, v

