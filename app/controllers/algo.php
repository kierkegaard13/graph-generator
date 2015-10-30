<?php

class Algo extends BaseController {

	public function postIndex()
	{
        $data = Input::get('data');
        $name = Input::get('name');
        $myfile = fopen("./txt_files/graph_$name.txt", "w") or die("Unable to open file!");
        $out = '';
        $data = join($data, "\n");
        fwrite($myfile, $data);
        fclose($myfile);
        exec("./c_scripts/$name < ./txt_files/graph_$name.txt", $out);
        return $out;
	}


}
