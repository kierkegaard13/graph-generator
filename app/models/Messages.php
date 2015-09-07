<?php

class Messages extends EloquentBridge 
{
	protected $table = "messages";
	public $timestamps = true;

	public function descendants(){
		if($this->path){
			$omitted = Messages::where('path','LIKE',"$this->path%")->where('res_num','=','7')->where('y_dim','=',$this->y_dim + 1)->first();
		}else{
			$omitted = '';
		}
		if($omitted){
			return $this->hasMany('Messages','parent')->where('path','<',$omitted->path)->where('res_num','<=','6')->where('y_dim','<=','2')->orderBy('path');
		}else{
			return $this->hasMany('Messages','parent')->where('res_num','<=','6')->where('y_dim','<=','2')->orderBy('path');
		}
	}

	public function mssgParent(){
		return $this->belongsTo('Messages','responseto');
	}

	public function chat(){
		return $this->belongsTo('Chats','chat_id');
	}
}
