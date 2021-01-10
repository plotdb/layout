# chart-layout

Compute chart layout by HTML/CSS.


# Usage

We will need 3 elements in following classes:

 - chart: root element
 - chart-layout: provide layout information with `cell` div for `g` (group) with the class named after `name` attr.
 - chart-render: containing `g` (group) element corresponding to `cell` in `chart-layout`.

A sample DOM structure in Pug:
 
    #my-chart.chart
      .chart-layout
        .cell(name="yaxis")
        .cell(name="view")
        .cell
        .cell(name="xaxis")
      .chart-render
        svg
          g.yaxis
          g.view: rect(ld-each="data")
          g
          g.xaxis


then, init with JS:

    mylayout = new layout({root: '#my-chart'})
    mylayout.on \render, ->
      d3.select('g.view').call ->
        /* get corresponding node and related size (box{x,y,width,height}) information */
        @layout{node, box}
      @get-box('name') # get bounding box with given name
      @get-node('name') # get DOM node with given name
      @get-group('name') # get `g` (group) with given name
    mylayout.init -> ... /* initializing ... */
