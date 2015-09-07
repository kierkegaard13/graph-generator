<?php

class Chats extends EloquentBridge 
{
	protected $table = "chats";
	public $timestamps = true;

	public function notValidUpdate(){
		return Validator::make(
				$this->toArray(),
				array(
					'title' => "between:5,$this->max_title_length",
					'description' => "max:$this->max_static_length",
					'communities' => 'max:120'
				     )
				)->fails();
	}

	public function notValidInsert(){
		return Validator::make(
				$this->toArray(),
				array(
					'title' => "required|between:5,$this->max_title_length",
					'description' => "max:$this->max_static_length",
					'communities' => 'max:120'
				     )
				)->fails();
	}

	public static function boot(){
		parent::boot();
		Chats::creating(function($chat){
			if($chat->notValidInsert()) return false;
		});
		Chats::updating(function($chat){
			if($chat->notValidUpdate()) return false;
		});
	}

	public function author(){
		if(preg_match('/[a-zA-Z]/',$this->admin)){
			return $this->belongsTo('User','admin_id');
		}else{
			return $this->belongsTo('Serials','admin_id');
		}
	}

	public function messages(){
		$mssg_count = count(DB::table('messages')->where('chat_id',$this->id)->get());
		if($this->type == 'public'){
			$limit = 1000;
			$order = 'path';
		}else{
			$limit = 25;
			$order = 'created_at';
		}
		if($mssg_count > $limit){
			return $this->hasMany('Messages','chat_id')->skip($mssg_count - 25)->take(25)->orderBy($order);
		}else{
			return $this->hasMany('Messages','chat_id')->orderBy($order);
		}
	}

	public function messagesOnly(){
		$mssg_count = count(DB::table('messages')->where('chat_id',$this->id)->whereresponseto('0')->get());
		if($mssg_count > 1000){
			return $this->hasMany('Messages','chat_id')->whereresponseto('0')->skip($mssg_count - 1000)->take(1000)->orderBy('path');
		}else{
			return $this->hasMany('Messages','chat_id')->whereresponseto('0')->orderBy('path');
		}
	}

	public function messagesPaginate(){
		return $this->hasMany('Messages','chat_id')->select('messages.*',DB::raw('(case when (upvotes - downvotes > 0) then log(upvotes - downvotes) + timestampdiff(minute,"2013-1-1 12:00:00",created_at)/45000 when (upvotes - downvotes = 0) then log(1) + timestampdiff(minute,"2013-1-1 12:00:00",created_at)/45000 else log(1/abs(upvotes - downvotes)) + timestampdiff(minute,"2013-1-1 12:00:00",created_at)/45000 end) AS score'))->whereresponseto('0')->with('descendants')->orderBy(DB::raw('score'),'desc')->paginate(25);
	}

	public function communities(){
		return $this->belongsToMany('Communities','chats_to_communities','chat_id','community_id')->withPivot(DB::raw('removed AS community_removed'));
	}

	public function voted(){
		return $this->belongsToMany('User','chats_voted','chat_id','user_id');
	}

	public function moderators(){
		return $this->hasMany('UsersToChats','chat_id')->select('user')->whereis_mod(1);
	}

	public function users(){
		return $this->belongsToMany('User','users_to_chats','chat_id','user_id')->wherebanned(0)->whereis_user(1)->withPivot('is_admin','is_mod','active')->orderBy(DB::raw('users_to_chats.is_admin'),'desc')->orderBy(DB::raw('users_to_chats.is_mod'),'desc');
	}

	public function seen(){
		if(Auth::check()){
			return count(UsersToChats::select('id')->whereuser_id(Auth::user()->id)->wherechat_id($this->id)->first());
		}else{
			return count(UsersToChats::select('id')->whereuser_id(Session::get('serial_id'))->wherechat_id($this->id)->first());
		}
	}

	public function friends(){
		return $this->belongsToMany('User','users_to_chats','chat_id','user_id')->where('user_id','!=',Auth::user()->id)->whereentity_type(0);
	}
}
