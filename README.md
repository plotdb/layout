# @plotdb/layout

Compute chart layout by HTML/CSS.


# Usage

We will need 3 elements:

 - root node: containing layout and render node. should set with `pdl-layout` class.
 - layout node: provide layout information with `div.pdl-cell` for `g.pdl-cell` with the same `data-name` attr.
 - render node: containing `g.pdl-cell` element corresponding to `pdl-cell` in layout node.

A sample DOM structure in Pug:
 
    #my-chart.pdl-layout
      div(data-type="layout")
        .pdl-cell(data-name="yaxis")
        .pdl-cell(data-name="view")
        .pdl-cell
        .pdl-cell(data-name="xaxis")
      div(data-type="render")
        svg
          g.pdl-cell(data-name="yaxis")
          g.pdl-cell(data-name="view"): rect(ld-each="data")
          g
          g.pdl-cell(data-name="xaxis")


then, init with JS:

    mylayout = new layout({root: '#my-chart'})
    mylayout.on \render, ->
      d3.select('g.pdl-cell[data-name=view]').call ->
        /* get corresponding node and related size (box{x,y,width,height}) information */
        @layout{node, box}
      @get-box('name') # get bounding box with given name
      @get-node('name') # get DOM node with given name
      @get-group('name') # get `g` (group) with given name
    mylayout.init -> ... /* initializing ... */


## Configuration

 - `autoSvg`: true if automatically create corresponding `svg` and `g` element. default true
   - even with `autoSvg` enabled, user can still prepare partial svg / g elements. `@plotdb/layout` will fill the missing parts automatically.
