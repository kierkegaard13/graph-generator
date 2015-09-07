<?php

class UsersToCommunities extends EloquentBridge 
{
	protected $table = "users_to_communities";
	public $timestamps = true;

	public function community(){
		return $this->belongsTo('Communities','community_id');
	}

	public function user(){
		return $this->belongsTo('User','user_id');
	}
}
