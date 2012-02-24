
/*
 * GET home page.
 */

phantom = require('phantom');

exports.index = function(req, res){
  res.render('index', { title: 'Express' })
};

exports.take = function(req, res){
	phantom.create(function(ph) {
	  ph.createPage(function(page) {
	   page.open(req.body.url, function(status) {  
	      page.render('test.png', function(){
	        console.log('done writing file');
	        res.send("Finished writing: " + req.body.url);
	        ph.exit();
	      })
	    });
	  });
	});
	
};