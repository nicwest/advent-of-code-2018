
var part1 = {
  form: document.getElementById("form"),
  results: document.getElementById("results"),
  grid: undefined,
  calculate: function() {
    var data = new FormData(this);
    var input = data.get('input');
    var lines = input.split("\n");
    var used = {};
    var conflicting = 0;
    var clearIds = [];
    for(var i=0; i<lines.length; i++){
      var line = lines[i];
      var id, x, y, w, h;
      var [id, x, y, w, h] = line.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/)
                                 .slice(1, 6)
                                 .map(x => parseInt(x));
      var clear = true;
      w = x + w;
      h = y + h;
      Y = y;
      for(;x<w;x++){
        var y = Y;
        for(;y<h;y++){
          var d = used[[x, y]];
          switch(d) {
            case undefined:
              used[[x, y]] = id;
              break;
            default:
              clear = false;
              clearIds = clearIds.filter(clearId => clearId != d);
              conflicting++;
              break;
          }
        }
      }

      if(clear) {
        clearIds.push(id);
      }
    }
    part1.results.innerHTML = 'conflicting: ' + conflicting + '\nclear IDS: ' 
                              + clearIds.join(", ");
    return false;
  },

  setup: function() {
    this.form.onsubmit = this.calculate;
  },
}

part1.setup();

