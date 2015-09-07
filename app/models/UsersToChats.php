<?php

class UsersToChats extends EloquentBridge 
{
	protected $table = "users_to_chats";

	public function friend(){
		return $this->belongsTo('User','friend_id');
	}
}
