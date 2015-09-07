<?php

class EloquentBridge extends Eloquent
{
	public $timestamps = false;
	protected $max_title_length = 300;
	protected $max_chat_mssg_length = 2500;
	protected $max_static_length = 10000;
	protected $max_description_length = 100;
	protected $max_info_length = 10000;
	protected $max_user_length = 20;

	public function getTable(){
		return $this->table;
	}

	public function getAttributes(){
		return $this->attributes;
	}

	public function findAll($single = 0)
	{
		$model_atts = $this->getAttributes();
		$table = explode('_',$this->getTable());
		array_walk($table,function(&$item,$index){ $item = ucfirst($item); });
		$table = implode('',$table);
		if($table == 'Users'){
			$result = new User();
		}else{
			$result = new $table();
		}
		foreach($model_atts as $traitname => $trait){
			$result = $result->where($traitname,$trait);
		}
		if($single){
			$result = $result->first();
		}else{
			$result = $result->get();
			if(count($result) == 0){
				$result = array();
			}else if(count($result) == 1){
				$result = $result[0];
			}
		}
		return $result;
	}

}

