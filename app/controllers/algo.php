<?php

class Algo extends BaseController {

	/*
	   |--------------------------------------------------------------------------
	   | Default Home Controller
	   |--------------------------------------------------------------------------
	   |
	   | You may wish to use controllers instead of, or in addition to, Closure
	   | based routes. That's great! Here is an example controller method to
	   | get you started. To route to this controller, just add the route:
	   |
	   |	Route::get('/', 'HomeController@showWelcome');
	   |
	 */

	public function getIndex()
	{
        $data = Input::get('data');
        $name = Input::get('name');
        $myfile = fopen("graph_$name.txt", "w") or die("Unable to open file!");
        $out = '';
        $data = join($data, "\n");
        fwrite($myfile, $data);
        fclose($myfile);
        exec("./$name < graph_$name.txt", $out);
        return $out;
	}


}
