var buildify = require('buildify');

buildify.task({
	name:'minify',
	task:function(){
		buildify().load('app.js')
			.uglify()
			.save('app.min.js');
	}
});

buildify.task({
	name:'concat',
	task:function(){
	/*	buildify().concat(['common.js','home.js'])
			.uglify()
			.save('home.min.js');
		buildify().concat(['common.js','chat.js'])
			.uglify()
			.save('chat.min.js');
	*/	buildify().concat(['routing.js','functions.js','startup.js','server.js','click_events.js','key_events.js','blur_events.js','submit_events.js'])
			.save('app.js')
			.uglify()
			.save('app.min.js');
		buildify().load('bootstrap.js')
			.uglify()
			.save('bootstrap.min.js');
	}
});

