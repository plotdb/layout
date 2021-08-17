var randText, ml;
randText = function(){
  var str, start, offset;
  str = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.  Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
  start = Math.round(Math.random() * str.length / 2);
  offset = Math.round(Math.random() * 20 + 5);
  return str.substring(start, start + offset);
};
ml = new layout({
  root: '.pdl-layout'
});
ml.init(function(){
  var legends, legends2, data, this$ = this;
  legends = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map(function(d, i){
    return {
      key: d,
      text: randText()
    };
  });
  legends2 = [0, 1, 2, 3, 4, 5].map(function(d, i){
    return {
      key: d,
      text: randText()
    };
  });
  /*
  legend = new pd-legend do
    root: '.pdl-layout', data: legends, layout: ml
    shape: (d) -> d3.select(@).attr \fill, <[#f00 #0f0 #00f]>[d.key % 3]
  legend-bottom = new pd-legend {root: '.pdl-layout', name: 'legend-bottom', data: legends2, layout: ml}
  */
  data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map(function(){
    return Math.round(Math.random() * 100);
  });
  ml.on('render', function(){
    var box, ref$;
    ml.update(false);
    box = this.getBox('view');
    ((ref$ = this.lc || (this.lc = {})).scale || (ref$.scale = {})).y = d3.scaleLinear().range([box.height, 0]).domain([0, Math.max.apply(Math, data)]);
    this.lc.scale.x = d3.scaleBand().range([0, box.width]).domain([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
    d3.select(this.getGroup('xaxis')).call(d3.axisBottom(this.lc.scale.x));
    d3.select(this.getGroup('yaxis')).call(d3.axisLeft(this.lc.scale.y)).attr('transform', function(){
      return "translate(" + (this.layout.box.width + this.layout.box.x) + ", 0)";
    });
    return this.lc.view.render();
  });
  return (this.lc || (this.lc = {})).view = new ldView({
    root: ld$.find('div[data-type=render]', 0),
    initRender: false,
    handler: {
      data: {
        list: function(){
          return data;
        },
        handler: function(arg$){
          var node, data, idx, bw, scale, attrs, k, v, results$ = [];
          node = arg$.node, data = arg$.data, idx = arg$.idx;
          bw = this$.lc.scale.x.bandwidth();
          scale = this$.lc.scale;
          attrs = {
            x: scale.x(idx) + 1,
            y: scale.y(data),
            width: scale.x.bandwidth() - 2,
            height: scale.y(0) - scale.y(data)
          };
          for (k in attrs) {
            v = attrs[k];
            results$.push(node.setAttribute(k, v));
          }
          return results$;
        }
      }
    }
  });
});