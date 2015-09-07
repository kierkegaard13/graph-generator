<?php

class Concepts extends EloquentBridge 
{
	protected $table = "concepts";

	public function users(){
		return $this->morphedByMany('User','entity','entities_to_concepts','concept_id','entity_id');
	}

	public function communities(){
		return $this->morphedByMany('Communities','entity','entities_to_concepts','concept_id','entity_id');
	}

}
