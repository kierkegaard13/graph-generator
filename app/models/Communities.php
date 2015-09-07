<?php

class Communities extends EloquentBridge 
{
	protected $table = "communities";
	public $timestamps = true;

	public function setNameAttribute($value){
		$this->attributes['name'] = preg_replace('/[^a-zA-Z0-9_\-.]/','',$value);
	}

	public function notValidUpdate(){
		return Validator::make(
				$this->toArray(),
				array(
					'description' => "max:$this->max_description_length",
					'info' => "max:$this->max_info_length"
				     )
				)->fails();
	}

	public function notValidInsert(){
		return Validator::make(
				$this->toArray(),
				array(
					'name' => 'required|between:3,20|unique:communities',
					'description' => "max:$this->max_description_length",
					'info' => "max:$this->max_info_length"
				     )
				)->fails();
	}

	public static function boot(){
		parent::boot();
		Communities::creating(function($communities){
			if($communities->notValidInsert()) return false;
		});
		Communities::updating(function($communities){
			if($communities->notValidUpdate()) return false;
		});
	}

	public function __toString(){
		return $this->name;
	}

	public function concept(){
		return $this->belongsTo('Concepts','concept_id');
	}

	public function about(){
		return $this->morphToMany('Concepts','entity','entities_to_concepts','entity_id','concept_id');
	}

	public function chats(){
		return Chats::select('chats.*',DB::raw('chats_to_communities.pinned as community_pinned'),DB::raw('(case when (chats_to_communities.upvotes - chats_to_communities.downvotes > 0) then log(chats_to_communities.upvotes - chats_to_communities.downvotes) + timestampdiff(minute,"2013-1-1 12:00:00",chats.created_at)/45000 when (chats_to_communities.upvotes - chats_to_communities.downvotes = 0) then log(1) + timestampdiff(minute,"2013-1-1 12:00:00",chats.created_at)/45000 else log(1/abs(chats_to_communities.upvotes - chats_to_communities.downvotes)) + timestampdiff(minute,"2013-1-1 12:00:00",chats.created_at)/45000 end) AS score'))->join('chats_to_communities','chats_to_communities.chat_id','=','chats.id')->where('chats_to_communities.community_id',$this->id)->where('chats_to_communities.removed','0')->where('chats.removed','0')->with('communities');
	}

	public function chatsnew(){
		return Chats::select('chats.*')->join('chats_to_communities','chats_to_communities.chat_id','=','chats.id')->where('chats_to_communities.community_id',$this->id)->where('chats.removed','0')->where('chats_to_communities.removed','0')->with('communities');
	}

	public function chatsrising(){
		return Chats::select('chats.*',DB::raw('(chats_to_communities.upvotes - chats_to_communities.downvotes) - views AS score'))->join('chats_to_communities','chats_to_communities.chat_id','=','chats.id')->where('chats_to_communities.community_id',$this->id)->where('chats.removed','0')->where('chats_to_communities.removed','0')->with('communities');
	}

	public function chatsremoved(){
		return Chats::select('chats.*')->join('chats_to_communities','chats_to_communities.chat_id','=','chats.id')->where('chats_to_communities.community_id',$this->id)->where('chats.removed','0')->where('chats_to_communities.removed','1')->with('communities');
	}

	public function subscribers(){
		return $this->belongsToMany('User','users_to_communities','community_id','user_id');
	}

	public function online(){
		return count(User::wherepage($this->name)->get());
	}
	
	public function moderators(){
		$mods = UsersToCommunities::wherecommunity_id($this->id)->whereis_mod('1')->get();
		$mod_arr = array();
		foreach($mods as $mod){
			$mod_arr[] = $mod->user_id;
		}
		return $mod_arr;
	}
}
