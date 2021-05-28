data = [0 to 20].map -> Math.round(Math.random! * 100)

ml = new layout root: '.pd-layout'
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

