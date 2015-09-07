<?php

class BaseController extends Controller {

	protected $base_url = 'http://localhost/graph';
	protected $site_url = 'http://graph.com';
	protected $io_url = 'localhost:3000';
	protected $file_url = '/var/www/laravel';
	protected $max_title_length = 300;
	protected $max_chat_mssg_length = 2500;
	protected $max_static_length = 10000;
	protected $max_description_length = 100;
	protected $max_info_length = 10000;
	protected $max_user_length = 20;
	protected $view_cache_en = 1;

	/**
	 * Setup the layout used by the controller.
	 *
	 * @return void
	 */
	public function __construct(){
		if(Auth::check()){
			View::share('user',Auth::user());
			View::share('logged_in','1');
		}else{
			View::share('user','');
			View::share('logged_in','0');
		}
		View::share('base', $this->base_url);
		$this->sid = Session::getId();
	}

	public function isXhr(){
		if(isset($_SERVER["HTTP_X_REQUESTED_WITH"]) AND strtolower($_SERVER["HTTP_X_REQUESTED_WITH"]) == "xmlhttprequest"){
			return 1;
		}else{
			return 0;
		}
	}

	public function compareTimes($time1, $format = 'minutes', $time2 = null){
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
		/* test if time1 > time2 
		$years_eq = $year1 == $year2;
		$weeks_eq = $week1 == $week2;
		$days_eq = $day1 == $day2;
		$hours_eq = $hour1 == $hour2;
		if($year1 > $year2 || ($years_eq && ($week1 > $week2 || ($weeks_eq && ($day1 > $day2 || ($days_eq && ($hour1 > $hour2 || ($hours_eq && $minute1 > $minute2)))))))){
		}else{
		}
		*/
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

	public function nextLevel($level){
		return 98 + 50000/(1 + exp(10 - $level));
	}

	public function previousLevel($cognizance){
		return ceil(10 - log(50000/($cognizance - 98) - 1));
	}

	public function youtubeLogo(){
		return $this->base_url . '/YouTube-logo-full_color.png';
	}

	public function lastQuery(){
		$queries = DB::getQueryLog();
		return end($queries);
	}	

	public function parseText($text){
		$pure_txt = $text;
		$text = $this->htmlEscapeAndLinkUrls($text);
		$text = Parsedown::instance()->setBreaksEnabled(true)->text($text);
		$reg3 = '/(img)(\s)(alt)/';
		$text = preg_replace('/^<p>/','',$text);
		$text = preg_replace('/<\/p>$/','',$text);
		$text = preg_replace($reg3,"$1$2style='max-width:300px;max-height:200px;margin-bottom:5px;' $3",$text);
		if(preg_match("/\/u\/([^\s]*)(<)/",$text)){
			$text = preg_replace("/\/p\/([^\s]*)(<)/","<a class='chat_link' href='\/\/mutualcog.com/u/$1'>/u/$1</a>$2",$text);
		}else{
			$text = preg_replace("/\/p\/([^\s]*)(\s*)/","<a class='chat_link' href='\/\/mutualcog.com/u/$1'>/u/$1</a>$2",$text);
		}
		if(preg_match("/\/c\/([^\s]*)(<)/",$text)){
			$text = preg_replace("/\/t\/([^\s]*)(<)/","<a class='chat_link' href='\/\/mutualcog.com/c/$1'>/t/$1</a>$2",$text);
		}else{
			$text = preg_replace("/\/t\/([^\s]*)(\s*)/","<a class='chat_link' href='\/\/mutualcog.com/c/$1'>/t/$1</a>$2",$text);
		}
		if(preg_match("/\@([^\s]*)(<)/",$text)){
			$text = preg_replace("/\@([^\s]*)(<)/","<a class='chat_link' href='\/\/mutualcog.com/u/$1'>@$1</a>$2",$text);
		}else{
			$text = preg_replace("/\@([^\s]*)(\s*)/","<a class='chat_link' href='\/\/mutualcog.com/u/$1'>@$1</a>$2",$text);
		}
		if(preg_match("/\#([^\s]*)(<)/",$text)){
			$text = preg_replace("/\#([^\s]*)(<)/","<a class='chat_link' href='\/\/mutualcog.com/c/$1'>#$1</a>$2",$text);
		}else{
			$text = preg_replace("/\#([^\s]*)(\s*)/","<a class='chat_link' href='\/\/mutualcog.com/c/$1'>#$1</a>$2",$text);
		}
		$patterns = array('/&gt;:\\|/','/&gt;:\\(/','/&lt;3/','/:\\)/','/:D/','/:\\|/',"/:\\'\\(/",'/:O/','/:P/','/T_T/','/:\\(/');
		$replace = array(
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/angry.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/rage.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/heart.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/smile.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/smiley.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/neutral_face.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/cry.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/open_mouth.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/stuck_out_tongue_closed_eyes.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/sob.png"></img>',
			'<img style="height:18px;" src="' . $this->base_url . '/app/emoji/disappointed.png"></img>'
			//'<img style="height:18px;" src="//localhost/laravel/app/emoji/confused.png"></img>'
		);
		$text = preg_replace($patterns,$replace,$text);
		return $text;
	}

	public function nodeAuth(){
		$node = new NodeAuth();
		$node->user_id = Auth::user()->id;
		$node->user = Auth::user()->name;
		$node->serial_id = Auth::user()->serial_id;
		if($node->findAll(1)){
			$node = $node->findAll(1);
		}
		$node->serial = Session::get('unique_serial');
		$node->serial_id = Session::get('serial_id');
		$node->sid = Session::getId();
		$node->authorized = 1;
		$node->save();
	}

	public function popVotedChats(&$upvoted,&$downvoted){
		foreach(Auth::user()->upvotedChats() as $upvote){
			$upvoted[] = $upvote->chat_id;
		}
		foreach(Auth::user()->downvotedChats() as $downvote){
			$downvoted[] = $downvote->chat_id;
		}
	}

	public function returnToCurrPage(){
		if(Session::has('curr_page')){
			return Redirect::to(Session::get('curr_page'));
		}
		return Redirect::to('home');
	}

	public function voteEntity($type,$entity_type){  //status is 1 for upvote, 0 for none, -1 for downvote
		$entity_id = Input::get('id');
		$member = Auth::user()->id;
		$status = 0;
		$user_exists = 0;
		if($entity_type){  //Voting on a chat
			$entity = Chats::find($entity_id);
			$voted = new ChatsVoted();
			$temp = $voted->whereuser_id($member)->wherechat_id($entity_id)->first();
			$community = Communities::wherename(Auth::user()->page)->first();
			if($temp){
				$voted = $temp;
				$status = $voted->status;
			}else{
				$voted->user_id = $member;
				$voted->chat_id = $entity_id;
			}
			if(preg_match('/[a-zA-Z]/',$entity->admin)){
				$user = new User();
				$user->name = $entity->admin;
				$user = $user->findAll();
				$user_exists = 1;
			}
		}else{  //voting on a message
			$entity = Messages::find($entity_id);
			$voted = new MessagesVoted();
			$temp = $voted->whereuser_id($member)->wheremessage_id($entity_id)->first();
			if($temp){
				$voted = $temp;
				$status = $voted->status;
			}else{
				$voted->user_id = $member;
				$voted->message_id = $entity_id;
			}
			if(preg_match('/[a-zA-Z]/',$entity->author)){
				$user = new User();
				$user->name = $entity->author;
				$user = $user->findAll();
				$user_exists = 1;
			}
		}
		/* MODIFY USER COGNIZANCE BASED ON UP OR DOWN VOTE */
		if($user_exists){
			if($user->name != Auth::user()->name){  // create/modify asymmetric interaction
				$interaction_user = InteractionUsers::whereuser_id(Auth::user()->id)->whereentity_id($user->id)->wheretype(0)->first();
				if($interaction_user){
					$interaction_user->bond = $interaction_user->bond - $status + $type;
					if($interaction_user->bond < 1){
						$interaction_user->delete();
					}else{
						$interaction_user->save();
					}
					$interaction_friend = InteractionUsers::whereentity_id(Auth::user()->id)->whereuser_id($user->id)->wheretype(0)->first();
					if($interaction_friend->bond < 1){
						$interaction_friend->delete();
					}else{
						$interaction_friend->save();
					}
					$interaction_friend->save();
				}else{
					if($type - $status > 0){
						$inter_user = new InteractionUsers();
						$inter_user->user_id = Auth::user()->id;
						$inter_user->entity_id = $user->id;
						$inter_user->bond = $type - $status;
						$inter_user->save();
						$inter_friend = new InteractionUsers();
						$inter_friend->user_id = $user->id;
						$inter_friend->entity_id = Auth::user()->id;
						$inter_friend->bond = 1;
						$inter_friend->save();
					}
				}
			}
			if($user->level == 0){
				if($type == -1 && ($status == 0 || $status == -1)){
				}else if($type == 1 && $status == -1){
					$user->total_cognizance = $user->total_cognizance + 1;
					if($user->cognizance + 1 >= $user->next_level){
						$user->cognizance = ($user->cognizance + 1) % $user->next_level;
						$user->level = $user->level + 1;
						$user->next_level = $this->nextLevel($user->level);
					}else{
						$user->cognizance = ($user->cognizance + 1) % $user->next_level;
					}
				}else if(($type == -1 && $status == 1) || ($type == 1 && $status == 1)){
					$user->total_cognizance = $user->total_cognizance - 1;
					if($user->level > 0 && $user->cognizance - 1 < 0){
						$user->level = $user->level - 1;
						$user->next_level = $this->nextLevel($user->level);
						$user->cognizance = $user->next_level - 1;
					}else{
						$user->cognizance = ($user->cognizance - 1) % $user->next_level;
					}
				}else{
					$user->total_cognizance = $user->total_cognizance - $status + $type;
					if($user->cognizance - $status + $type >= $user->next_level){
						$user->cognizance = ($user->cognizance - $status + $type) % $user->next_level;
						$user->level = $user->level + 1;
						$user->next_level = $this->nextLevel($user->level);
					}else{
						$user->cognizance = ($user->cognizance - $status + $type) % $user->next_level;
					}
				}
			}else{
				$user->total_cognizance = $user->total_cognizance - $status + $type;
				if($user->cognizance - $status + $type >= $user->next_level){
					$user->cognizance = ($user->cognizance - $status + $type) % $user->next_level;
					$user->level = $user->level + 1;
					$user->next_level = $this->nextLevel($user->level);
				}else if($user->level > 0 && $user->cognizance - $status + $type < 0){
					$user->level = $user->level - 1;
					$user->next_level = $this->nextLevel($user->level);
					$user->cognizance = $user->next_level - $status + $type;
				}else{
					$user->cognizance = ($user->cognizance - $status + $type) % $user->next_level;
				}
			}
			$user->save();
		}
		if($entity_type){
			foreach($entity->communities as $community){
				$usercommunity = UsersToCommunities::wherecommunity_id($community->id)->whereuser_id(Auth::user()->id)->first();
				if($usercommunity){
					$usercommunity->score = $usercommunity->score - $status + $type;
					$usercommunity->save();
				}
				$community->popularity = $community->popularity - $status + $type;
				$community->save();
			}
		}
		/* MODIFY MESSAGE OR CHAT UPVOTES AND DOWNVOTES */
		if($entity_type){
			$chat_to_community = ChatsToCommunities::wherechat_id($entity->id)->wherecommunity_id($community->id)->first();
			if($chat_to_community){
				$chat_to_community->upvotes = ($type == $status && $type == 1) ? $chat_to_community->upvotes - 1 : (($type != $status && $type == 1) ? $chat_to_community->upvotes + 1 : (($status == 1 && $type == -1) ? $chat_to_community->upvotes - 1 : $chat_to_community->upvotes));
				$chat_to_community->downvotes = ($type == $status && $type == -1) ? $chat_to_community->downvotes - 1 : (($type != $status && $type == -1) ? $chat_to_community->downvotes + 1 : (($status == -1 && $type == 1) ? $chat_to_community->downvotes - 1 : $chat_to_community->downvotes));
				$chat_to_community->save();
			}else{
				$chat_to_communities = ChatsToCommunities::wherechat_id($chat_to_community->id)->get();
				foreach($chat_to_communities as $chat_to_community){
					$chat_to_community->upvotes = ($type == $status && $type == 1) ? $chat_to_community->upvotes - 1 : (($type != $status && $type == 1) ? $chat_to_community->upvotes + 1 : (($status == 1 && $type == -1) ? $chat_to_community->upvotes - 1 : $chat_to_community->upvotes));
					$chat_to_community->downvotes = ($type == $status && $type == -1) ? $chat_to_community->downvotes - 1 : (($type != $status && $type == -1) ? $chat_to_community->downvotes + 1 : (($status == -1 && $type == 1) ? $chat_to_community->downvotes - 1 : $chat_to_community->downvotes));
					$chat_to_community->save();
				}
			}
		}
		$entity->upvotes = ($type == $status && $type == 1) ? $entity->upvotes - 1 : (($type != $status && $type == 1) ? $entity->upvotes + 1 : (($status == 1 && $type == -1) ? $entity->upvotes - 1 : $entity->upvotes));
		$entity->downvotes = ($type == $status && $type == -1) ? $entity->downvotes - 1 : (($type != $status && $type == -1) ? $entity->downvotes + 1 : (($status == -1 && $type == 1) ? $entity->downvotes - 1 : $entity->downvotes));
		$entity->save();
		if($type == 1 && $status == -1){  //downvoted previously and now upvoted
			$voted->status = 1;
			$voted->save();
			return array('status' => 1,'upvotes' => $entity->upvotes - $entity->downvotes);
		}elseif($type == -1 && $status == 1){ // upvoted previously and now downvoted
			$voted->status = -1;
			$voted->save();
			return array('status' => 1,'upvotes' => $entity->upvotes - $entity->downvotes);
		}elseif(($status == 1 && $type == 1) || ($status == 0 && $type == -1)){  //upvoted previously or first time downvoting
			if($type == 1){
				$voted->status = 0;
				$voted->save();
				return array('status' => 2,'upvotes' => $entity->upvotes - $entity->downvotes);
			}else{
				$voted->status = -1;	
				$voted->save();
				return array('status' => 3,'upvotes' => $entity->upvotes - $entity->downvotes);
			}
		}else{  //first time upvoting or downvoted previously now downvoted
			if($type == 1){
				$voted->status = 1;	
				$voted->save();
				return array('status' => 3,'upvotes' => $entity->upvotes - $entity->downvotes);
			}else{
				$voted->status = 0;
				$voted->save();
				return array('status' => 2,'upvotes' => $entity->upvotes - $entity->downvotes);
			}
		}
	}

	protected function setupLayout()
	{
		if ( ! is_null($this->layout))
		{
			$this->layout = View::make($this->layout);
		}
	}

	/*
	 *  Transforms plain text into valid HTML, escaping special characters and
	 *  turning URLs into links.
	 */
	public function htmlEscapeAndLinkUrls($text)
	{
		/*
		 *  Regular expression bits used by htmlEscapeAndLinkUrls() to match URLs.
		 */
		$rexScheme    = 'https?://';
		// $rexScheme    = "$rexScheme|ftp://"; // Uncomment this line to allow FTP addresses.
		$rexDomain    = '(?:[-a-zA-Z0-9\x7f-\xff]{1,63}\.)+[a-zA-Z\x7f-\xff][-a-zA-Z0-9\x7f-\xff]{1,62}';
		$rexIp        = '(?:[1-9][0-9]{0,2}\.|0\.){3}(?:[1-9][0-9]{0,2}|0)';
		$rexPort      = '(:[0-9]{1,5})?';
		$rexPath      = '(/[!$-/0-9:;=@_\':;!a-zA-Z\x7f-\xff]*?)?';
		$rexQuery     = '(\?[!$-/0-9:;=@_\':;!a-zA-Z\x7f-\xff]+?)?';
		$rexFragment  = '(#[!$-/0-9?:;=@_\':;!a-zA-Z\x7f-\xff]+?)?';
		$rexUsername  = '[^]\\\\\x00-\x20\"(),:-<>[\x7f-\xff]{1,64}';
		$rexPassword  = $rexUsername; // allow the same characters as in the username
		$rexUrl       = "($rexScheme)?(?:($rexUsername)(:$rexPassword)?@)?($rexDomain|$rexIp)($rexPort$rexPath$rexQuery$rexFragment)";
		$rexTrailPunct= "[)'?.!,;:]"; // valid URL characters which are not part of the URL if they appear at the very end
		$rexNonUrl    = "[^-_#$+.!*%'(),;/?:@=&a-zA-Z0-9\x7f-\xff]"; // characters that should never appear in a URL
		$rexUrlLinker = "{\\b$rexUrl(?=$rexTrailPunct*($rexNonUrl|$))}";
		// $rexUrlLinker .= 'i'; // Uncomment this line to allow uppercase URL schemes (e.g. "HTTP://google.com").

		/*
		 *  $validTlds is an associative array mapping valid TLDs to the value true.
		 *  Since the set of valid TLDs is not static, this array should be updated
		 *  from time to time.
		 *
		 *  List source:  http://data.iana.org/TLD/tlds-alpha-by-domain.txt
		 *  Last updated: 2014-06-05
		 */
		$validTlds = array_fill_keys(explode(" ", ".ac .academy .accountants .actor .ad .ae .aero .af .ag .agency .ai .airforce .al .am .an .ao .aq .ar .archi .army .arpa .as .asia .associates .at .attorney .au .audio .autos .aw .ax .axa .az .ba .bar .bargains .bayern .bb .bd .be .beer .berlin .best .bf .bg .bh .bi .bid .bike .bio .biz .bj .black .blackfriday .blue .bm .bn .bo .boutique .br .bs .bt .build .builders .buzz .bv .bw .by .bz .ca .cab .camera .camp .capital .cards .care .career .careers .cash .cat .catering .cc .cd .center .ceo .cf .cg .ch .cheap .christmas .church .ci .citic .ck .cl .claims .cleaning .clinic .clothing .club .cm .cn .co .codes .coffee .college .cologne .com .community .company .computer .condos .construction .consulting .contractors .cooking .cool .coop .country .cr .credit .creditcard .cruises .cu .cv .cw .cx .cy .cz .dance .dating .de .degree .democrat .dental .dentist .desi .diamonds .digital .directory .discount .dj .dk .dm .dnp .do .domains .dz .ec .edu .education .ee .eg .email .engineer .engineering .enterprises .equipment .er .es .estate .et .eu .eus .events .exchange .expert .exposed .fail .farm .feedback .fi .finance .financial .fish .fishing .fitness .fj .fk .flights .florist .fm .fo .foo .foundation .fr .frogans .fund .furniture .futbol .ga .gal .gallery .gb .gd .ge .gf .gg .gh .gi .gift .gives .gl .glass .globo .gm .gmo .gn .gop .gov .gp .gq .gr .graphics .gratis .gripe .gs .gt .gu .guide .guitars .guru .gw .gy .hamburg .haus .hiphop .hiv .hk .hm .hn .holdings .holiday .homes .horse .host .house .hr .ht .hu .id .ie .il .im .immobilien .in .industries .info .ink .institute .insure .int .international .investments .io .iq .ir .is .it .je .jetzt .jm .jo .jobs .jp .juegos .kaufen .ke .kg .kh .ki .kim .kitchen .kiwi .km .kn .koeln .kp .kr .kred .kw .ky .kz .la .land .lawyer .lb .lc .lease .li .life .lighting .limited .limo .link .lk .loans .london .lr .ls .lt .lu .luxe .luxury .lv .ly .ma .maison .management .mango .market .marketing .mc .md .me .media .meet .menu .mg .mh .miami .mil .mk .ml .mm .mn .mo .mobi .moda .moe .monash .mortgage .moscow .motorcycles .mp .mq .mr .ms .mt .mu .museum .mv .mw .mx .my .mz .na .nagoya .name .navy .nc .ne .net .neustar .nf .ng .nhk .ni .ninja .nl .no .np .nr .nu .nyc .nz .okinawa .om .onl .org .pa .paris .partners .parts .pe .pf .pg .ph .photo .photography .photos .pics .pictures .pink .pk .pl .plumbing .pm .pn .post .pr .press .pro .productions .properties .ps .pt .pub .pw .py .qa .qpon .quebec .re .recipes .red .rehab .reise .reisen .ren .rentals .repair .report .republican .rest .reviews .rich .rio .ro .rocks .rodeo .rs .ru .ruhr .rw .ryukyu .sa .saarland .sb .sc .schule .sd .se .services .sexy .sg .sh .shiksha .shoes .si .singles .sj .sk .sl .sm .sn .so .social .software .sohu .solar .solutions .soy .space .sr .st .su .supplies .supply .support .surgery .sv .sx .sy .systems .sz .tattoo .tax .tc .td .technology .tel .tf .tg .th .tienda .tips .tirol .tj .tk .tl .tm .tn .to .today .tokyo .tools .town .toys .tp .tr .trade .training .travel .tt .tv .tw .tz .ua .ug .uk .university .uno .us .uy .uz .va .vacations .vc .ve .vegas .ventures .versicherung .vet .vg .vi .viajes .villas .vision .vn .vodka .vote .voting .voto .voyage .vu .wang .watch .webcam .website .wed .wf .wien .wiki .works .ws .wtc .wtf .xn--3bst00m .xn--3ds443g .xn--3e0b707e .xn--45brj9c .xn--4gbrim .xn--55qw42g .xn--55qx5d .xn--6frz82g .xn--6qq986b3xl .xn--80adxhks .xn--80ao21a .xn--80asehdb .xn--80aswg .xn--90a3ac .xn--c1avg .xn--cg4bki .xn--clchc0ea0b2g2a9gcd .xn--czr694b .xn--czru2d .xn--d1acj3b .xn--fiq228c5hs .xn--fiq64b .xn--fiqs8s .xn--fiqz9s .xn--fpcrj9c3d .xn--fzc2c9e2c .xn--gecrj9c .xn--h2brj9c .xn--i1b6b1a6a2e .xn--io0a7i .xn--j1amh .xn--j6w193g .xn--kprw13d .xn--kpry57d .xn--l1acc .xn--lgbbat1ad8j .xn--mgb9awbf .xn--mgba3a4f16a .xn--mgbaam7a8h .xn--mgbab2bd .xn--mgbayh7gpa .xn--mgbbh1a71e .xn--mgbc0a9azcg .xn--mgberp4a5d4ar .xn--mgbx4cd0ab .xn--ngbc5azd .xn--nqv7f .xn--nqv7fs00ema .xn--o3cw4h .xn--ogbpf8fl .xn--p1ai .xn--pgbs0dh .xn--q9jyb4c .xn--rhqv96g .xn--s9brj9c .xn--ses554g .xn--unup4y .xn--wgbh1c .xn--wgbl6a .xn--xkc2dl3a5ee0h .xn--xkc2al3hye2a .xn--yfro4i67o .xn--ygbi2ammx .xn--zfr164b .xxx .xyz .yachts .ye .yokohama .yt .za .zm .zw .zone"), true);

		$html = '';

		$position = 0;
		while (preg_match($rexUrlLinker, $text, $match, PREG_OFFSET_CAPTURE, $position))
		{
			list($url, $urlPosition) = $match[0];

			// Add the text leading up to the URL.
			$html .= htmlspecialchars(substr($text, $position, $urlPosition - $position));

			$scheme      = $match[1][0];
			$username    = $match[2][0];
			$password    = $match[3][0];
			$domain      = $match[4][0];
			$afterDomain = $match[5][0]; // everything following the domain
			$port        = $match[6][0];
			$path        = $match[7][0];

			// Check that the TLD is valid or that $domain is an IP address.
			$tld = strtolower(strrchr($domain, '.'));
			if (preg_match('{^\.[0-9]{1,3}$}', $tld) || isset($validTlds[$tld]))
			{
				// Do not permit implicit scheme if a password is specified, as
				// this causes too many errors (e.g. "my email:foo@example.org").
				if (!$scheme && $password)
				{
					$html .= htmlspecialchars($username);

					// Continue text parsing at the ':' following the "username".
					$position = $urlPosition + strlen($username);
					continue;
				}

				if (!$scheme && $username && !$password && !$afterDomain)
				{
					// Looks like an email address.
					$completeUrl = "mailto:$url";
					$linkText = $url;
				}
				else
				{
					// Prepend http:// if no scheme is specified
					$completeUrl = $scheme ? $url : "http://$url";
					$linkText = "$domain$port$path";
				}$linkHtml = '<a class="chat_link" href="' . htmlspecialchars($completeUrl) . '">'
				. htmlspecialchars($linkText)
					. '</a>';

				// Cheap e-mail obfuscation to trick the dumbest mail harvesters.
				$linkHtml = str_replace('@', '&#64;', $linkHtml);

				// Add the hyperlink.
				$html .= $linkHtml;
			}
			else
			{
				// Not a valid URL.
				$html .= htmlspecialchars($url);
			}

			// Continue text parsing from after the URL.
			$position = $urlPosition + strlen($url);
		}

		// Add the remainder of the text.
		$html .= htmlspecialchars(substr($text, $position));
		return $html;
	}

	/*
	 * Turns URLs into links in a piece of valid HTML/XHTML.
	 *
	 * Beware: Never render HTML from untrusted sources. Rendering HTML provided by
	 * a malicious user can lead to system compromise through cross-site scripting.
	 */
	public function linkUrlsInTrustedHtml($html)
	{
		$reMarkup = '{</?([a-z]+)([^"\'>]|"[^"]*"|\'[^\']*\')*>|&#?[a-zA-Z0-9]+;|$}';

		$insideAnchorTag = false;
		$position = 0;
		$result = '';

		// Iterate over every piece of markup in the HTML.
		while (true)
		{
			preg_match($reMarkup, $html, $match, PREG_OFFSET_CAPTURE, $position);

			list($markup, $markupPosition) = $match[0];

			// Process text leading up to the markup.
			$text = substr($html, $position, $markupPosition - $position);

			// Link URLs unless we're inside an anchor tag.
			if (!$insideAnchorTag) $text = $this->htmlEscapeAndLinkUrls($text);

			$result .= $text;// End of HTML?
			if ($markup === '') break;

			// Check if markup is an anchor tag ('<a>', '</a>').
			if ($markup[0] !== '&' && $match[1][0] === 'a')
				$insideAnchorTag = ($markup[1] !== '/');

			// Pass markup through unchanged.
			$result .= $markup;

			// Continue after the markup.
			$position = $markupPosition + strlen($markup);
		}
		return $result;
	}
}
