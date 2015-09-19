var ui = function() {
'use strict';
var width = $('.graph_cont').width(),
	height = $('.graph_cont').height();

// typical graph node radius
var SMALL_RAD = 15;

// graph node radius when you've moused over it
var BIG_RAD = 20;
var color = d3.scale.category20();

// used for determining whether interaction was a click or a drag
var clicked;

// indicates whether the graph is currently being dragged/panned
var dragging;
// mapping feature names to ints that control edge coloring

var Graph = function(graph) {
	var link, linkText, node, force, svg, container;
    var highlighted = [];
	var adj = [];
	var nodes = [];
	var links = [];
	var linked_by_index = {};
	var center = 0;
	var oldCenter = -1;
	var centerX = 0;
	var centerY = 0;
	var that = this;

	var zoomed = function() {
		container.attr('transform', 'translate(' + d3.event.translate + ') scale(' + d3.event.scale + ')');
	};

	var zoom = d3.behavior.zoom()
		.scaleExtent([0.1, 2])
		.on('zoom', zoomed);

	this.inspectNodes = function() {
		return nodes;
	};

	this.inspectLinks = function() {
		return links;
	};

	this.constructForceLayout = function(link_mult) {
		$('svg').remove();
		link_mult = (typeof(link_mult) === 'undefined') ? 1 : link_mult;
		force = d3.layout.force()
			.charge(-6000)
			.linkDistance(200 * link_mult)
			.linkStrength(.2)
			.size([width, height])
			.links(links)
			.nodes(nodes)
			.on('tick', this.tick);
		svg = d3.select('.graph_cont').append('svg')
			.attr('width', width)
			.attr('height', height)
			.call(zoom)
			.on('dblclick.zoom', null);
		container = svg.append('g');
	};

	this.clearNodes = function(link_mult) {
		nodes = [];
		links = [];
		this.constructForceLayout(link_mult);
	};

	this.refreshNodes = function() {
		$.each(nodes, function(index, val) {
			val.fixed = true;
		});
	};

	this.neighboring = function(a, b){
		console.log(a, b);
		return a === b || linked_by_index[a + '-' + b];
	}

	this.buildLinks = function(type){
		var min_w, max_w;
		min_w = parseInt($('#min_w').val());
		max_w = parseInt($('#max_w').val());
		adj = [];
		for(var i = 0; i < nodes.length; i++)
			adj.push([]);
		switch(type){
			case 'tree':
				var bf, target_node, node_list = [], Q = [];
				for(var i = 1; i < nodes.length; i++)
					node_list.push(nodes[i]);
				Q.push(nodes[0]);
				while(node_list.length !== 0){
					bf = Math.floor((Math.random() * 5) + 1);
					for(var i = 0; i < bf; i++){
						if(node_list.length > 0){
							target_node = Math.floor(Math.random() * (node_list.length - 1));
							links.push({source: nodes[Q[0].id], target: nodes[node_list[target_node].id],
								 type: 0, weight: Math.floor((Math.random() * max_w) + min_w)});	
							adj[Q[0].id].push(node_list[target_node].id);
							adj[node_list[target_node].id].push(Q[0].id);
							Q.push(node_list[target_node]);
							node_list.splice(target_node, 1);
						}else{
							break;
						}
					}
					Q.shift();
				}
				break;
			case 'btree':
				var target_node, node_list = [], Q = [];
				for(var i = 1; i < nodes.length; i++)
					node_list.push(nodes[i]);
				Q.push(nodes[0]);
				while(node_list.length !== 0){
					for(var i = 0; i < 2; i++){
						if(node_list.length > 0){
							target_node = Math.floor(Math.random() * (node_list.length - 1));
							links.push({source: nodes[Q[0].id], target: nodes[node_list[target_node].id],
								 type: 0, weight: Math.floor((Math.random() * max_w) + min_w)});	
							adj[Q[0].id].push(node_list[target_node].id);
							adj[node_list[target_node].id].push(Q[0].id);
							Q.push(node_list[target_node]);
							node_list.splice(target_node, 1);
						}else{
							break;
						}
					}
					Q.shift();
				}
				break;
			case 'sparse':
				var rem, target_node, source_node, source_node_id, edges, total_edges, n, node_list = [], undiscovered;
				n = nodes.length;
				total_edges = Math.floor((Math.random() * ((n * (n - 1)) / 4 - 1 - n)) + n);
				edges = Math.ceil(total_edges / n);
				rem = total_edges % n;
				for(var i = 0; i < nodes.length; i++)
					node_list.push(nodes[i]);
				while(node_list.length !== 0){
					/* source_node_id is index in node_list while source_node.id is index in nodes */
					source_node_id = Math.floor(Math.random() * (node_list.length - 1));
					source_node = node_list[source_node_id];
					node_list.splice(source_node_id, 1);
					undiscovered = [];
					for(var i = 0; i < n; i++){
						if(adj[i].indexOf(source_node.id) === -1)
							undiscovered.push(nodes[i]);
					}
					for(var i = 0; i < edges; i++){
						if(undiscovered.length > 0){
							target_node = Math.floor(Math.random() * (undiscovered.length - 1));
							links.push({source: nodes[source_node.id], target: undiscovered[target_node],
								 type: 0, weight: Math.floor((Math.random() * max_w) + min_w)});	
							adj[source_node.id].push(undiscovered[target_node].id);
							adj[undiscovered[target_node].id].push(source_node.id);
							undiscovered.splice(target_node, 1);
							rem--;
						}else{
							break;
						}
						/* Decrease number of edges per vertex when remainder -> 0 */
						if(rem == 0){
							edges--;
							rem = total_edges;
						}
					}
				}
				break;
			case 'dense':
				var rem, target_node, source_node, source_node_id, edges, total_edges, n, node_list = [], undiscovered;
				n = nodes.length;
				total_edges = Math.floor((Math.random() * ((n * (n - 1)) / 4 - 1 - n)) + n + (((n * (n - 1)) / 4)));
				edges = Math.ceil(total_edges / n);
				rem = total_edges % n;
				for(var i = 0; i < n; i++)
					node_list.push(nodes[i]);
				while(node_list.length !== 0){
					source_node_id = Math.floor(Math.random() * (node_list.length - 1));
					source_node = node_list[source_node_id];
					node_list.splice(source_node_id, 1);
					undiscovered = [];
					for(var i = 0; i < n; i++){
						if(adj[i].indexOf(source_node.id) === -1)
							undiscovered.push(nodes[i]);
					}
					for(var i = 0; i < edges; i++){
						if(undiscovered.length > 0){
							target_node = Math.floor(Math.random() * (undiscovered.length - 1));
							links.push({source: nodes[source_node.id], target: undiscovered[target_node],
								 type: 0, weight: Math.floor((Math.random() * max_w) + min_w)});	
							adj[source_node.id].push(undiscovered[target_node].id);
							adj[undiscovered[target_node].id].push(source_node.id);
							undiscovered.splice(target_node, 1);
							rem--;
						}else{
							break;
						}
						if(rem == 0){
							edges--;
							rem = total_edges;
						}
					}
				}
				break;
			case 'full':
				for(var i = 0; i < nodes.length; i++){
					for(var j = i + 1; j < nodes.length; j++){
						links.push({source: nodes[i], target: nodes[j],
							 type: 0, weight: Math.floor((Math.random() * max_w) + min_w)});
						adj[i].push(j);
						adj[j].push(i);
					}
				}
				break;
			default:
				break;
		}
		$('#graph_data').html('');
		$('#graph_data').append('<div>' + nodes.length + ' ' + links.length + '</div>');
		linked_by_index = {};
		for(var i = 0; i < links.length; i++){
			linked_by_index[links[i].source.id + '-' + links[i].target.id] = 1;
			linked_by_index[links[i].target.id + '-' + links[i].source.id] = 1;
			$('#graph_data').append('<div>' + links[i].source.id + ' ' + links[i].target.id + ' ' + links[i].weight + '</div>');
		}
	}

	this.buildNodes = function(vertices, type) {
		var position;
		oldCenter = center;
		center = 0;
		if(type === 'sparse')
			this.clearNodes(2);
		else if(type === 'dense')
			this.clearNodes(4);
		else if(type === 'full')
			this.clearNodes(8);
		else{
			vertices[0].group = 1;
			this.clearNodes();
		}
		for(var i = 0; i < vertices.length; i++){
			var vertex = vertices[i];
			vertex.x = width / 2;
			vertex.y = height / 2;
			nodes.push(vertex);
		}
		this.buildLinks(type);
	};

    this.findEdge = function(source, target) {
        var item = null;
        source = parseInt(source);
        target = parseInt(target);
        for(var i = 0; i < links.length; i++){
            if(links[i].source.id === source && links[i].target.id === target){
                item = links[i];
                return {'dom': $('#link_' + source + '_' + target), 'item': item};
            }else if(links[i].source.id === target && links[i].target.id === source){
                item = links[i];
                return {'dom': $('#link_' + target + '_' + source), 'item': item};
            }
        }
        return null;
    }

    this.highlightEdge = function(source, target){
        var edge = $('#link_' + source + '_' + target);
        if(edge.length === 0)
            edge = $('#link_' + target + '_' + source);
        edge.find('.link-line').css('stroke', 'red');
    }

    this.highlightEdges = function(edges){
        var edge;
        for(var i = highlighted.length - 1; i >= 0; i--){
            edge = this.findEdge(highlighted[i].source, highlighted[i].target);
            if(edge){
                edge.dom.find('.link-line').css('stroke', color(edge.item.type));
            }
            highlighted.pop();
        }
        for(var i = 0; i < edges.length; i++){
            this.highlightEdge(edges[i].source, edges[i].target);
            highlighted.push(edges[i]);
        }
    }

	this.refreshGraph = function() {
		link = container.selectAll('.link');
		link = link.data(force.links());
		link.enter().append('g')
			.attr('class', 'link')
            .attr('id', function(d) { return 'link_' + d.source.id + '_' + d.target.id; })
			.append('line')
			.attr('class', 'link-line')
			.attr('stroke-width', 3)
			.style('stroke', function(d) { return color(d.type); })
			.call(force.drag);

		linkText = svg.selectAll(".link")
			.append("text")
			.attr("class", "link-label")
			.attr("font-family", "Arial, Helvetica, sans-serif")
			.attr("fill", "Black")
			.style("font", "normal 16px Arial")
			.attr("dy", ".35em")
			.attr("text-anchor", "middle")
			.text(function(d) { return d.weight; });

		node = container.selectAll('.node');
		node = node.data(force.nodes());
		node.enter().insert("circle", ".cursor")
			.attr('title', 'hi')
			.attr("class", "node")
			.attr("r", SMALL_RAD)
			.attr('id', function(d) { return 'node_' + d.id; })
			.style('fill', function(d) { return color(d.group); })
			.on('mouseover', function(d){
					container.selectAll('.node')
						.transition()
						.duration(500)
						.attr('opacity', function(o){
							return that.neighboring(d.id, o.id) ? 1 : .3;		
						});
					container.selectAll('.link-line')
						.transition()
						.duration(500)
						.attr('opacity', function(o){
							return o.source.id == d.id || o.target.id == d.id ? 1 : .3;
						});
				})
			.on('mouseout', function(){
					container.selectAll('.node')
						.transition()
						.duration(500)
						.attr('opacity', 1);
					container.selectAll('.link-line')
						.transition()
						.duration(500)
						.attr('opacity', 1);
				})
			.call(force.drag);

		force.start();
	};

	this.tick = function(event) {
		node.attr("cx", function(d) { return d.x; })
			.attr("cy", function(d) { return d.y; });

		container.selectAll('.link-line').attr('x1', function(d) { return d.source.x; })
			.attr('y1', function(d) { return d.source.y; })
			.attr('x2', function(d) { return d.target.x; })
			.attr('y2', function(d) { return d.target.y; });

		linkText.attr("x", function(d) {
					return ((d.source.x + d.target.x)/2 + 15);
				})
			.attr("y", function(d) {
					return ((d.source.y + d.target.y)/2 + 15);
				});
	};

};

//Create initial graph
var graph = new Graph();

$(document).on('ready', function() {
	var vertex_list = [];
	for(var i = 0; i < 20; i++){
		vertex_list.push({id: i});
	}
	graph.buildNodes(vertex_list, 'tree');
	graph.refreshGraph();
});

$('#graph_randomize').on('click', function(){
	var num, type, vertex_list = [];
	num = $('#num_nodes').val();
	type = $('#graph_type').val();
	for(var i = 0; i < num; i++){
		vertex_list.push({id: i});
	}
	graph.buildNodes(vertex_list, type);
});

$('#graph_visualize').on('click', function(){
	graph.refreshGraph();
});

$('#graph_highlight').on('click', function(){
    var edges;
    edges = $('#highlight_edges').html().replace(/<\/div>/g,'').replace(/\n/g,'').split('<div>');
    for(var i = 0; i < edges.length; i++){
        edges[i].trim();
        edges[i] = {'source': edges[i].split(' ')[0], 'target': edges[i].split(' ')[1]};
    }
    graph.highlightEdges(edges);
});

return graph;

}();
