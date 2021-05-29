rand-text = ->
  str = """Lorem Ipsum is simply dummy text of the printing and typesetting industry.  Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."""
  start = Math.round(Math.random! * str.length / 2)
  offset = Math.round(Math.random! * 20 + 5)
  return str.substring(start, start + offset)


ml = new layout root: '.pdl-layout'
ml.init ->
  legends = [0 to 10].map (d,i) -> {key: d, text: rand-text!}
  legends2 = [0 to 5].map (d,i) -> {key: d, text: rand-text!}
  #legends = [0 to 0].map (d,i) -> {key: d, text: rand-text!}
  #legends2 = [0 to 0].map (d,i) -> {key: d, text: rand-text!}
  legend = new pd-legend do
    root: '.pdl-layout', data: legends, layout: ml
    shape: (d) -> d3.select(@).attr \fill, <[#f00 #0f0 #00f]>[d.key % 3]
  legend-bottom = new pd-legend {root: '.pdl-layout', name: 'legend-bottom', data: legends2, layout: ml}
  data = [0 to 20].map -> Math.round(Math.random! * 100)
  ml.on \render, ->
    ml.update false
    box = @get-box('view')
    @{}lc.{}scale.y = d3.scaleLinear!
      .range [box.height,0]
      .domain [0, Math.max.apply(Math, data)]
    @lc.scale.x = d3.scaleBand!
      .range [0, box.width]
      .domain [0 to 20]
    d3.select @get-group \xaxis .call d3.axis-bottom(@lc.scale.x)
    d3.select @get-group \yaxis
      .call d3.axis-Left(@lc.scale.y)
      .attr \transform, -> "translate(#{@layout.box.width + @layout.box.x}, 0)"
    @lc.view.render!

  @{}lc.view = new ldView do
    root: ld$.find 'div[data-type=render]', 0
    init-render: false
    handler:
      data:
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
