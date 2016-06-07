var mysql      = require('mysql'),
	express    = require('express'),
	app        = express(),
	connection = mysql.createConnection({ user: 'curtis', database: 'n'}),
	io         = require('socket.io')(3001),
	sockets    = {};

var allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    next()
}

io.on('connection', function (socket) {
	sockets[socket.id] = socket;
	socket.on('disconnect', function () {
		delete sockets[socket.id]
  })
});

app.use(allowCrossDomain);
app.use('/', express.static('static'));

app.post('/fetchItems', function(req, res) {
	fetchItems(success, error);

	function error() {
		res.status(500).send("Error while finding items")
	}

	function success(rows) {
		res.json(rows)
	}
});

app.post('/buySkeletor', function(req, res) {
	connection.query('select num_stocked from items where id = 2', function(err, rows) {
		if (err || !rows.length) {
			error();
			return
		}

		var count = rows[0].num_stocked;
		if (!count) {
			error();
			return
		}

		connection.query('update items set num_stocked = ? where id = 2', count - 1, function(err, _) {
			if (err) {
				error();
				return
			}

			res.send("success\n")
			for (var key in sockets) {
				sockets[key].emit('update_counts')
			}
		})
	});

	function error() {
		res.status(500).send("Error while buying Skeletor")
	}
});

connection.connect(startListener);

function startListener() {
	app.listen(3000, function () { console.log('Ready') });	
}

function fetchItems(cbk_success, cbk_error) {
	connection.query('select * from items', function(err, rows) {
	  if (err) {
	  	cbk_error();
	  	return
	  }
	 
	  cbk_success(rows)
	});
}
