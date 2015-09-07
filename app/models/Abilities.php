<?php

class Abilities extends EloquentBridge 
{
	protected $table = "abilities";

	public function users(){
		return $this->belongsToMany('User','users_to_abilities','ability_id','user_id');
	}

}
