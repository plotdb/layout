var data, ml;
data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map(function(){
  return Math.round(Math.random() * 100);
});
ml = new layout({
  root: '.pd-layout'
});
ml.on('render', function(){
  var box, ref$;
  box = this.getBox('view');
  ((ref$ = this.lc || (this.lc = {})).scale || (ref$.scale = {})).y = d3.scaleLinear().range([box.height, 0]).domain([0, Math.max.apply(Math, data)]);
  this.lc.scale.x = d3.scaleBand().range([0, box.width]).domain([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
  d3.select(this.getGroup('xaxis')).call(d3.axisBottom(this.lc.scale.x));
  d3.select(this.getGroup('yaxis')).attr('transform', function(){
    return "translate(" + (this.layout.box.width + this.layout.box.x) + ",0)";
  }).call(d3.axisLeft(this.lc.scale.y));
  return this.lc.view.render();
});
ml.init(function(){
  var this$ = this;
  return (this.lc || (this.lc = {})).view = new ldView({
    root: ld$.find('g.view', 0),
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