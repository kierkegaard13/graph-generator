<?php

class UsersToSaved extends EloquentBridge 
{
	protected $table = "users_to_saved";
	public $timestamps = true;

	public function savedEntity(){
		if($this->saved_type == 'chats'){
			return $this->belongsTo('Chats','saved_id');
		}else{
			return $this->belongsTo('Messages','saved_id');
		}
	}

	public function user(){
		return $this->belongsTo('User','user_id');
	}
}
