var HashMap = function() {
	var mapValue = [];
	var pos = new Array();

	this.get = function(key) {
		return mapValue[key];
	};

	this.getKey = function(n) {
		return pos[n];
	};

	this.getPos = function(n) {
		return mapValue[pos[n]];
	};

	this.remove = function(n) {
		var array = new Array();
		for (var i = 0; i < map.size(); i++) {
			if (i != n) {
				array.push(pos[i]);
			}
		}
		pos = array;
	};

	this.put = function(key, value) {
		mapValue[key] = value;

		var flag = true;
		for (var i = 0; i < pos.length; i++) {
			if (key == pos[i]) {
				flag = false;
			}
		}

		if (flag) {
			pos.push(key);
		}
	};

	this.size = function() {
		return pos.length;
	};
};
