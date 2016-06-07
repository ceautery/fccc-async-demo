var express = require('express'),
	path = require('path'),
	app = express();

app.get('/api', (req, res) => res.json( [{name: 'foo', val: 7}, {name: 'bar', val: 8}, {name: 'baz', val: 9}] ));

app.use('/jquery', express.static(path.join(__dirname, 'node_modules', 'jquery', 'dist')));
app.use('/angular', express.static(path.join(__dirname, 'node_modules', 'angular')));
app.use('/q', express.static(path.join(__dirname, 'node_modules', 'q')));

app.use('/', express.static(__dirname));

app.listen(3000, () => console.log('ready'));
