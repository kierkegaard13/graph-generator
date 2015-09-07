<?php

class InteractionUsers extends EloquentBridge 
{
	protected $table = "interaction_users";
	public $timestamps = true;

	public function user(){
		return $this->belongsTo('User','user_id');
	}

	public function entity(){
		return $this->belongsTo('User','entity_id');
	}
}
