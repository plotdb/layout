var data, layout, ml;
data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20].map(function(){
  return Math.round(Math.random() * 100);
});
layout = function(opt){
  opt == null && (opt = {});
  this.root = typeof opt.root === 'string'
    ? document.querySelector(opt.root)
    : opt.root;
  this.evtHandler = {};
  this.box = {};
  this.node = {};
  this.group = {};
  return this;
};
layout.prototype = import$(Object.create(Object.prototype), {
  on: function(n, cb){
    var ref$;
    return ((ref$ = this.evtHandler)[n] || (ref$[n] = [])).push(cb);
  },
  fire: function(n){
    var v, res$, i$, to$, ref$, len$, cb, results$ = [];
    res$ = [];
    for (i$ = 1, to$ = arguments.length; i$ < to$; ++i$) {
      res$.push(arguments[i$]);
    }
    v = res$;
    for (i$ = 0, len$ = (ref$ = this.evtHandler[n] || []).length; i$ < len$; ++i$) {
      cb = ref$[i$];
      results$.push(cb.apply(this, v));
    }
    return results$;
  },
  init: function(cb){
    var this$ = this;
    return Promise.resolve().then(function(){
      window.addEventListener('resize', function(){
        return this$.update();
      });
      cb.apply(this$);
      return this$.update();
    });
  },
  update: function(){
    var this$ = this;
    this.rbox = this.root.getBoundingClientRect();
    Array.from(this.root.querySelectorAll('.chart-layout .cell[name]')).map(function(node, i){
      var name, ref$, box, g;
      name = node.getAttribute('name');
      this$.node[name] = node;
      this$.box[name] = box = {
        x: (ref$ = node.getBoundingClientRect()).x,
        y: ref$.y,
        width: ref$.width,
        height: ref$.height
      };
      box.x -= this$.rbox.x;
      box.y -= this$.rbox.y;
      this$.group[name] = g = this$.root.querySelector("g." + name);
      g.setAttribute('transform', "translate(" + box.x + "," + box.y + ")");
      return g.layout = {
        node: node,
        box: box
      };
    });
    return this.fire('render');
  },
  getBox: function(it){
    return this.box[it];
  },
  getNode: function(it){
    return this.node[it];
  },
  getGroup: function(it){
    return this.group[it];
  }
});
ml = new layout({
  root: '.chart'
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
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}