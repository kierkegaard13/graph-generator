<?php

function nextLevel($level){
	return 98 + 50000/(1 + exp(10 - $level));
}

function compareTimes($time1, $format = 'minutes', $time2 = null){
	$time_diff = 0;
	$time1 = date('Y:W:w:H:i',strtotime($time1));
	if($time2){
		$time2 = date('Y:W:w:H:i',strtotime($time2));
	}else{
		$time2 = date('Y:W:w:H:i');
	}
	list($year1,$week1,$day1,$hour1,$minute1) = explode(':',$time1);
	list($year2,$week2,$day2,$hour2,$minute2) = explode(':',$time2);
	$year_diff = ($year1 - $year2) * 525949;
	$week_diff = ($week1 - $week2) * 10080;
	$day_diff = ($day1 - $day2) * 1440;
	$hour_diff = ($hour1 - $hour2) * 60;
	$minute_diff = $minute1 - $minute2;
	$time_diff = $year_diff + $week_diff + $day_diff + $hour_diff + $minute_diff;
	if($format == 'minutes'){
		return $time_diff;
	}else if($format == 'hours'){
		return $time_diff/60;
	}else if($format == 'days'){
		return $time_diff/1440;
	}else if($format == 'weeks'){
		return $time_diff/10080;
	}else{
		return $time_diff/525949;
	}
}

function getUniqueSerialNumber($serial_number=null){
	if(!$serial_number){
		$serial_number = mt_rand(2,268435455);
	}
	$serial = new Serials();
	$serial->serial_id = $serial_number;
	$temp = $serial->findAll();
	if($temp){  //serial number exists
		/* if temp is more than 8 hours old */
		if(abs(compareTimes($temp->updated_at)) > 1440){
			$temp->ip_address = Request::getClientIp();
			$temp->welcomed = 0;
			$temp->save();
			Session::put('unique_serial',$temp->serial_id);
			Session::put('serial_id',$temp->id);
			if(Auth::check()){
				Auth::user()->serial_id = $temp->id;
				Auth::user()->disconnecting = 0;
				Auth::user()->online = 1;
				Auth::user()->save();
				$node = new NodeAuth();
				$node->serial = $serial->serial_id;
				$node->sid = Session::getId();
				$node->authorized = 1;
				if($node->findAll()){
					$node = $node->findAll();
				}
				$node->user_id = Auth::user()->id;
				$node->user = Auth::user()->name;
				$node->serial_id = $serial->id;
				$node->save();
			}
			return true;
		}
		$serial_number = mt_rand(0,16777215);
		return getUniqueSerialNumber($serial_number);
	}
	$serial->ip_address = Request::getClientIp();
	$serial->welcomed = 0;
	$serial->save();
	Session::put('unique_serial',$serial->serial_id);
	Session::put('serial_id',$serial->id);
	if(Auth::check()){
		Auth::user()->serial_id = $serial->id;
		Auth::user()->disconnecting = 0;
		Auth::user()->online = 1;
		Auth::user()->save();
		$node = new NodeAuth();
		$node->serial = $serial->serial_id;
		$node->sid = Session::getId();
		$node->authorized = 1;
		if($node->findAll()){
			$node = $node->findAll();
		}
		$node->user_id = Auth::user()->id;
		$node->user = Auth::user()->name;
		$node->serial_id = $serial->id;
		$node->save();
	}
	return true;
}

/*
|--------------------------------------------------------------------------
| Application & Route Filters
|--------------------------------------------------------------------------
|
| Below you will find the "before" and "after" events for the application
| which may be used to do any work before or after a request into your
| application. Here you may also register your custom route filters.
|
*/

App::before(function($request)
{
	//
});


App::after(function($request, $response)
{
	//
});

/*
|--------------------------------------------------------------------------
| Authentication Filters
|--------------------------------------------------------------------------
|
| The following filters are used to verify that the user of the current
| session is logged into this application. The "basic" filter easily
| integrates HTTP Basic authentication for quick, simple checking.
|
*/

Route::filter('auth', function()
{
	if (Auth::guest()) return Redirect::guest('login');
});


Route::filter('auth.basic', function()
{
	return Auth::basic();
});

/*
|--------------------------------------------------------------------------
| Guest Filter
|--------------------------------------------------------------------------
|
| The "guest" filter is the counterpart of the authentication filters as
| it simply checks that the current user is not logged in. A redirect
| response will be issued if they are, which you may freely change.
|
*/

Route::filter('guest', function()
{
	if (Auth::check()) return Redirect::to('/');
});

/*
|--------------------------------------------------------------------------
| CSRF Protection Filter
|--------------------------------------------------------------------------
|
| The CSRF filter is responsible for protecting your application against
| cross-site request forgery attacks. If this special token in a user
| session does not match the one given in this request, we'll bail.
|
*/

Route::filter('csrf', function()
{
	if (Session::token() != Input::get('_token'))
	{
		throw new Illuminate\Session\TokenMismatchException;
	}
});


Route::filter('assignSerial',function(){
		if(!Session::has('unique_serial')){
			getUniqueSerialNumber();
			//TODO: iterate through connections to generate bond score
			/* each node has a base score of 1 * bond
			multiply times distance which is a max of 5
			check sec_id for matches to iteslf or first_id
			*/
			/*if(Auth::check()){
				$interactions = InteractionUsers::whereuser_id(Auth::user()->id)->wheretype(0)->wherefriended(1)->get();
				$first_id_arr = array();
				$second_id_arr = array();
				$second_info_arr = array();
				$passive = 0;
				foreach($interactions as $interaction){  //generate first level nodes
					if(abs(compareTimes($interaction->updated_at,'days')) > 2){
						if($interaction->bond > 1.05){
							$interaction->bond = 1.05;
						}else{
							$interaction->bond = $interaction->bond - .05;
						}
						$interaction->save();
					}
					if(array_key_exists($interaction->entity_id,$first_id_arr)){
						$first_id_arr[$interaction->entity_id] += 1;
					}else{
						$first_id_arr[$interaction->entity_id] = 1;
					}
					$sec_inters = InteractionUsers::whereuser_id($interaction->entity_id)->wheretype(0)->wherefriended(1)->get();
					foreach($sec_inters as $sec_inter){  //generate second level nodes
						if(array_key_exists($sec_inter->entity_id,$second_id_arr)){
							$second_id_arr[$sec_inter->entity_id] += 1;
						}else{
							$second_id_arr[$sec_inter->entity_id] = 1;
						}
						if(array_key_exists($interaction->entity_id,$second_info_arr)){
							$second_info_arr[$interaction->entity_id][] = $sec_inter->entity_id;
						}else{  //bond is attached to first level node which is attached to multiple second level nodes
							$second_info_arr[$interaction->entity_id] = array($interaction->bond,$sec_inter->entity_id);
						}  
					}
				}
				foreach($second_info_arr as $key => $second){  //each el is an array, key is first level id
					$loop_idx = 0;
					$distance = 5;
					foreach($second as $sec){  //each el is a second level id
						if($loop_idx != 0){
							if(array_key_exists($sec,$first_id_arr)){
								if($distance > 1){
									$distance -= 1;
								}
							}
							if($second_id_arr[$sec] > 1){
								if($distance > 1){
									$distance -= .5 * $second_id_arr[$sec];
									if($distance > 1){
										$distance = ceil($distance);
									}else{
										$distance = 1;
									}
								}
							}
						}
					}
					//passive = bond * distance
					$passive += $second[0] * $distance;
				}
				Auth::user()->passive = $passive;
				Auth::user()->total_cognizance += $passive;
				Auth::user()->cognizance = (Auth::user()->cognizance + $passive) % Auth::user()->next_level;
				if((Auth::user()->cognizance + $passive) >= Auth::user()->next_level){
					Auth::user()->level += 1;
					Auth::user()->next_level = nextLevel(Auth::user()->level); 
				}
				Auth::user()->save();
			}*/
		}else{
			$serial = Serials::whereserial_id(Session::get('unique_serial'))->first();
			if($serial){
				$serial->ip_address = Request::getClientIp();
				$serial->save();
				if(Auth::check()){
					Auth::user()->serial_id = $serial->id;
					Auth::user()->disconnecting = 0;
					Auth::user()->online = 1;
					Auth::user()->save();
				}
			}else{
				getUniqueSerialNumber();
			}
		}
		});

