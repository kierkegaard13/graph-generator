<?php

use Illuminate\Auth\UserInterface;
use Illuminate\Auth\Reminders\RemindableInterface;

class User extends EloquentBridge implements UserInterface, RemindableInterface 
{
	protected $table = "users";
	public $timestamps = true;

	protected $hidden = array('password');

	public function setNameAttribute($value){
		$this->attributes['name'] = ucfirst(preg_replace('/[^a-zA-Z0-9_\-.]/','',$value));
	}

	public function notValidUpdate(){
		return Validator::make(
				$this->toArray(),
				array(
					'email' => 'email'
				     )
				)->fails();
	}

	public function notValidInsert(){
		return Validator::make(
				$this->toArray(),
				array(
					'name' => "required|unique:users|between:3,$this->max_user_length",
					'password' => 'between:6,30',
					'email' => 'email'
				     )
				)->fails();
	}

	public static function boot(){
		parent::boot();
		User::creating(function($user){
			if($user->notValidInsert()) return false;
		});
		User::updating(function($user){
			if($user->notValidUpdate()) return false;
		});
	}

	/**
	 * Get the unique identifier for the user.
	 *
	 * @return mixed
	 */
	public function getRememberToken(){
		return $this->remember_token;
	}

	public function setRememberToken($value){
		$this->remember_token = $value;
	}

	public function getRememberTokenName(){
		return 'remember_token';
	}

	public function getAuthIdentifier()
	{
		return $this->getKey();
	}

	/**
	 * Get the password for the user.
	 *
	 * @return string
	 */
	public function getAuthPassword()
	{
		return $this->password;
	}

	/**
	 * Get the e-mail address where password reminders are sent.
	 *
	 * @return string
	 */
	public function getReminderEmail()
	{
		return $this->email;
	}
	
	public function getNameAttribute($value){
		return ucfirst($value);
	}

	public function serial(){
		return $this->belongsTo('Serials','serial_id');
	}

	public function interests(){
		return $this->morphToMany('Concepts','entity','entities_to_concepts','entity_id','concept_id');
	}

	public function savedMessages(){
		return $this->morphedByMany('Messages','saved','users_to_saved','user_id','saved_id')->select('messages.id');
	}

	public function savedChats(){
		return $this->morphedByMany('Chats','saved','users_to_saved','user_id','saved_id')->select('chats.id');
	}

	public function savedEntities(){
		return UsersToSaved::whereuser_id($this->id)->orderBy('created_at')->paginate(25);
	}

	public function messages(){
		return $this->hasMany('Messages','user_id')->wheretype('public');
	}

	public function messagesP(){
		return Messages::wheretype('public')->whereuser_id($this->id)->paginate(25);
	}

	public function privateChats(){
		return $this->belongsToMany('Chats','users_to_chats','user_id','chat_id')->wheretype('private')->where('visible','!=','0')->withPivot('visible','unseen');
	}

	public function privateChatF(){
		return $this->belongsToMany('Chats','users_to_chats','entity_id','chat_id')->wheretype('private')->whereuser_id(Auth::user()->id)->whereentity_type(0);
	}

	public function chats(){
		return $this->hasMany('Chats','admin_id');
	}

	public function chatsP(){
		return Chats::whereadmin_id($this->id)->with('communities')->paginate(25);
	}

	public function chatRoom(){
		return $this->belongsTo('Chats','chat_id')->wheretype('public')->take(1);
	}

	public function rooms(){
		return $this->belongsToMany('Chats','users_to_chats','user_id','chat_id');
	}

	public function recent(){
		return $this->belongsToMany('Chats','users_to_chats','user_id','chat_id')->take(20)->orderBy('updated_at','desc');
	}

	public function friendships(){
		return $this->hasMany('InteractionUsers','user_id')->wheretype(0)->wherefriended(1)->orderBy(DB::raw('bond + bond * timestampdiff(minute,"2013-1-1 12:00:00",interaction_users.updated_at)/45000'),'desc');
	}

	public function friendshipsP(){
		return InteractionUsers::wheretype(0)->wherefriended(1)->whereuser_id($this->id)->orderBy(DB::raw('bond + bond * timestampdiff(minute,"2013-1-1 12:00:00",interaction_users.updated_at)/45000'),'desc')->paginate(50);
	}

	public function subscriptions(){
		return $this->belongsToMany('Communities','users_to_communities','user_id','community_id');
	}

	public function subArr(){
		$tmp_arr =  User::select('users_to_communities.community_id')->where('users.id',$this->id)->join('users_to_communities','users_to_communities.user_id','=','users.id')->get()->toArray();
		$sub_arr = array();
		foreach($tmp_arr as $sub){
			$sub_arr[] = $sub['community_id'];
		}
		return $sub_arr;
	}

	public function owned(){
		return count(UsersToCommunities::select('id')->whereuser_id($this->id)->whereis_admin(1)->get());
	}

	public function upvotedChats(){
		return ChatsVoted::select('chat_id','status')->whereuser_id($this->id)->wherestatus(1)->take(1000)->get();
	}

	public function downvotedChats(){
		return ChatsVoted::select('chat_id','status')->whereuser_id($this->id)->wherestatus(-1)->take(1000)->get();
	}

	public function upvotedMessages(){
		return MessagesVoted::select('message_id','status')->whereuser_id($this->id)->wherestatus(1)->get();
	}

	public function downvotedMessages(){
		return MessagesVoted::select('message_id','status')->whereuser_id($this->id)->wherestatus(-1)->get();
	}

	public function notifications(){
		return $this->hasMany('Notifications','user_id');
	}

	public function globalNotifications(){
		return $this->hasMany('Notifications','user_id')->wheretype(0)->take(5);
	}

	public function mssgNotifications(){
		return $this->hasMany('Notifications','user_id')->wheretype(1)->take(5);
	}

	public function friendNotifications(){
		return $this->hasMany('Notifications','user_id')->wheretype(2)->take(5);
	}

	public function abilities(){
		return $this->belongsToMany('Abilities','users_to_abilities','user_id','ability_id')->withPivot('active','level','unlocked');
	}

	public function online_score(){
		$d1 = new Datetime($this->updated_at);
		$d2 = new Datetime(date(DATE_ATOM));
		$diff = $d1->diff($d2);
		$online = $diff->d*60*60*24 + $diff->h*60*60 + $diff->i*60 + $diff->s;
		return $online;
	}

	public function online(){
		$d1 = new Datetime($this->updated_at);
		$d2 = new Datetime(date(DATE_ATOM));
		$diff = $d1->diff($d2);
		$online_mssg = "Most recent activity ";
		if($diff->y > 0){
			$online_mssg = $online_mssg . "more than a year ago";	
		}else{
			if($diff->m > 0){
				if($diff->m == 1){
					$online_mssg = $online_mssg . "1 month ago";
				}else{
					$online_mssg = $online_mssg . $diff->m . " months ago";
				}	
			}else if($diff->d > 0){
				if($diff->d == 1){
					$online_mssg = $online_mssg . "1 day ago";
				}else{
					$online_mssg = $online_mssg . $diff->d . " days ago";
				}	
			}else if($diff->h > 0){
				if($diff->h == 1){
					$online_mssg = $online_mssg . "1 hour ago";
				}else{
					$online_mssg = $online_mssg . $diff->h . " hours ago";
				}	
			}else if($diff->i > 0){
				if($diff->i == 1){
					$online_mssg = $online_mssg . "1 minute ago";
				}else{
					$online_mssg = $online_mssg . $diff->i . " minutes ago";
				}	
			}else{
				if($diff->s == 1){
					$online_mssg = $online_mssg . "1 second ago";
				}else{
					$online_mssg = $online_mssg . $diff->s . " seconds ago";
				}	
			}
		}
		return $online_mssg;
	}

}
