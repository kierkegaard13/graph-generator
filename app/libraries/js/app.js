var ui = function() {
'use strict';
var width = $('.graph_cont').width(),
	height = $('.graph_cont').height();

// typical graph node radius
var SMALL_RAD = 20;

// graph node radius when you've moused over it
var BIG_RAD = 25;
var color = d3.scale.category20();
var EDGE_LIM = 1000;

// used for determining whether interaction was a click or a drag
var clicked;

// indicates whether the graph is currently being dragged/panned
var dragging;

// used for selecting graph type
var selected_option = -1;
var prev_text = '';

var spinner = '<div class="loader">' +
              '<div class="rect1"></div>' +
              '<div class="rect2"></div>' +
              '<div class="rect3"></div>' +
              '<div class="rect4"></div>' +
              '<div class="rect5"></div>' +
              '</div>';

jQuery.expr[':'].icontains = function(a, i, m) {
    return jQuery(a).text().toUpperCase()
        .indexOf(m[3].toUpperCase()) >= 0;
};

var Graph = function(graph) {
	var drag, link, linkText, linkTextShadow, labels, node, force, svg,
        container, total_edges, total_nodes, least_edges,
        most_edges, node_degree, loc_idx;
    loc_idx = 0;
    node_degree = 0;
    total_nodes = 0;
    total_edges = 0;
    least_edges = -1;
    most_edges = -1;
    var node_names = {};
    var locations = [[10,10],[10,-10],[-10,-10],[-10,10]];
    var highlighted = [];
	var adj = [];
	var nodes = [];
	var links = [];
	var linked_by_index = {};
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

	this.constructForceLayout = function() {
		$('svg').remove();
        var k = Math.sqrt(nodes.length / (width * height));
		force = d3.layout.force()
			.charge(function(d) {
                    var charge;
                    if(d.edges > 0)
                        charge = -3000 * (least_edges / d.edges) - 200;
                    else
                        charge = -3200;
                    return charge;
                })
			.linkDistance(function(d) {
                    var degree, ratio;
                    degree = ((d.source.edges / least_edges) + (d.target.edges / least_edges)) / 2;
                    ratio = .9 / (most_edges / least_edges);
                    degree *= ratio;
                    if(degree > 1) degree = 1;
                    return (80 * nodes.node_degree) * (1.2 - degree);
                })
			.linkStrength(.8)
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
        drag = force.drag()
            .on('dragstart', dragstarted)
            .on('dragend', dragended);
	};

    this.raiseError = function(message) {
        $('#error_modal .modal-body').html(message);
        $('#error_modal').modal('show');
    };

	this.clearNodes = function() {
		nodes = [];
		links = [];
        loc_idx = 0;
        total_nodes = 0;
        total_edges = 0;
        least_edges = -1;
        most_edges = -1;
        node_degree = 0;
        node_names = {};
	};

	this.refreshNodes = function() {
		$.each(nodes, function(index, val) {
			val.fixed = true;
		});
	};

	this.neighboring = function(a, b){
		return a === b || linked_by_index[a + '-' + b];
	};

    this.countNodes = function(){
        total_nodes = nodes.length;
        total_edges = links.length;
        $.each(nodes, function(idx, val){
            if(adj[val.id].length > 0 && (least_edges === -1 || adj[val.id].length < least_edges))
                least_edges = adj[val.id].length;
            if(adj[val.id].length > 0 && (most_edges === -1 || adj[val.id].length > most_edges))
                most_edges = adj[val.id].length;
            node_degree += adj[val.id].length;
            val.edges = adj[val.id].length;
        });
        node_degree = node_degree / total_nodes;
        nodes.node_degree = node_degree;
    };

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
							links.push({'source': nodes[Q[0].id],
                                        'target': nodes[node_list[target_node].id],
								        'type': 0,
                                        'weight': Math.floor((Math.random() * max_w) + min_w)});	
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
							links.push({'source': nodes[Q[0].id],
                                        'target': nodes[node_list[target_node].id],
								        'type': 0,
                                        'weight': Math.floor((Math.random() * max_w) + min_w)});	
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
							links.push({'source': nodes[source_node.id],
                                        'target': undiscovered[target_node],
								        'type': 0,
                                        'weight': Math.floor((Math.random() * max_w) + min_w)});	
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
							links.push({'source': nodes[source_node.id],
                                        'target': undiscovered[target_node],
								        'type': 0,
                                        'weight': Math.floor((Math.random() * max_w) + min_w)});	
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
						links.push({'source': nodes[i],
                                    'target': nodes[j],
							        'type': 0,
                                    'weight': Math.floor((Math.random() * max_w) + min_w)});
						adj[i].push(j);
						adj[j].push(i);
					}
				}
				break;
			case 'custom':
                var chance, prob = parseFloat($('#prob').val());
				for(var i = 0; i < nodes.length; i++){
					for(var j = i + 1; j < nodes.length; j++){
                        chance = Math.random() < prob;
                        if(chance === true){
                            links.push({'source': nodes[i],
                                        'target': nodes[j],
                                        'type': 0,
                                        'weight': Math.floor((Math.random() * max_w) + min_w)});
                            adj[i].push(j);
                            adj[j].push(i);
                        }
					}
				}
				break;
			default:
				break;
		}
		$('#graph_data').html('');
		$('#graph_data').append('<div>' + nodes.length + ' ' + links.length + '</div>');
		linked_by_index = {};
        this.countNodes();
		for(var i = 0; i < links.length; i++){
			linked_by_index[links[i].source.id + '-' + links[i].target.id] = 1;
			linked_by_index[links[i].target.id + '-' + links[i].source.id] = 1;
			$('#graph_data').append('<div>' + links[i].source.id + ' ' + links[i].target.id + ' ' + links[i].weight + '</div>');
		}
	}

	this.buildNodes = function(vertices, type) {
		var position;
		if(type === 'tree' || type === 'btree')
			vertices[0].group = 1;
        this.clearNodes();
		for(var i = 0; i < vertices.length; i++){
			var vertex = vertices[i];
			vertex.x = width / 2 + locations[loc_idx][0];
			vertex.y = height / 2 + locations[loc_idx][1];
            loc_idx = (loc_idx + 1) % locations.length;
			nodes.push(vertex);
		}
		this.buildLinks(type);
        $('#graph_build').html('Build');
	};

    this.buildGraphFromInput = function(){
        var num_nodes, num_edges, edge, data = $('#graph_data').html(),
            data_by_div, data_by_nl, node_idx;
        data_by_div = data.replace(/<\/div>/g,'').split(/<[^<>]*>/);
        data_by_nl = data.replace(/<[^<>]*>/g,'').split("\n");
        if(data_by_nl.length > 1)
            data = data_by_nl;
        else
            data = data_by_div;
        if(data[0] === '')
            data.splice(0,1);
        num_nodes = parseInt(data[0].split(' ')[0]);
        num_edges = parseInt(data[0].split(' ')[1]);
        node_idx = 0;
		adj = [];
        /* init empty adjacency list */
		for(var i = 0; i < num_nodes; i++)
			adj.push([]);
        this.clearNodes();
        /* loop through edge list and populate nodes and links */
        for(var i = 1; i <= num_edges; i++){
            if(data[i].length > 0){
                data[i].trim();
                edge = data[i].split(' ');
                /* reassign node names to a unique id */
                if(!node_names.hasOwnProperty(edge[0])){
                    node_names[edge[0]] = node_idx;
                    nodes.push({'id': node_idx, 'name': edge[0], 'x': width / 2 + locations[loc_idx][0], 'y': height / 2 + locations[loc_idx][1]});
                    loc_idx = (loc_idx + 1) % locations.length;
                    node_idx++;
                }
                if(!node_names.hasOwnProperty(edge[1])){
                    node_names[edge[1]] = node_idx;
                    nodes.push({'id': node_idx, 'name': edge[1], 'x': width / 2 + locations[loc_idx][0], 'y': height / 2 + locations[loc_idx][1]});
                    loc_idx = (loc_idx + 1) % locations.length;
                    node_idx++;
                }
                if(edge.length < 3)
                    edge = {'source': node_names[edge[0]], 'target': node_names[edge[1]], 'weight': undefined};
                else
                    edge = {'source': node_names[edge[0]], 'target': node_names[edge[1]], 'weight': parseFloat(edge[2])};
                if(edge.source >= num_nodes || edge.target >= num_nodes)
                    return 1;
                adj[edge.source].push(edge.target);
                adj[edge.target].push(edge.source);
                links.push({'source': nodes[edge.source], 'target': nodes[edge.target], 'type': 0, 'weight': edge.weight});
                linked_by_index = {};
                linked_by_index[edge.source + '-' + edge.target] = 1;
                linked_by_index[edge.target + '-' + edge.source] = 1;
            }
        }
        this.countNodes();
        return 0;
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

    this.dullEdge = function(source, target){
        var edge = $('#link_' + source + '_' + target);
        if(edge.length === 0)
            edge = $('#link_' + target + '_' + source);
        edge.find('.link-line').attr('opacity', .2);
        edge.find('.link-line').attr('dulled', 1);
    }

    this.highlightEdge = function(source, target){
        var edge = $('#link_' + source + '_' + target);
        if(edge.length === 0)
            edge = $('#link_' + target + '_' + source);
        edge.find('.link-line').attr('opacity', 1);
        edge.find('.link-line').attr('dulled', '');
        edge.find('.link-line').css('stroke', 'red');
    }

    this.highlightEdges = function(edges){
        var edge;
        if(edges.length === 1){
            for(var i = 0; i < links.length; i++){
                edge = this.findEdge(links[i].source.id, links[i].target.id);
                if(edge){
                    edge.dom.find('.link-line').css('stroke', color(edge.item.type));
                    edge.dom.find('.link-line').attr('opacity', 1);
                    edge.dom.find('.link-line').attr('dulled', '');
                }
            }
        }else{
            for(var i = 0; i < links.length; i++)
                this.dullEdge(links[i].source.id, links[i].target.id);
        }
        for(var i = highlighted.length - 1; i >= 0; i--){
            edge = this.findEdge(highlighted[i].source, highlighted[i].target);
            if(edge)
                edge.dom.find('.link-line').css('stroke', color(edge.item.type));
            highlighted.pop();
        }
        for(var i = 0; i < edges.length; i++){
            if(Object.keys(node_names).length > 0)
                this.highlightEdge(node_names[String(edges[i].source)], node_names[String(edges[i].target)]);
            else
                this.highlightEdge(edges[i].source, edges[i].target);
            highlighted.push(edges[i]);
        }
    }

    this.algo = function(name){
        var that = this, data = $('#graph_data').html(), data_by_div, data_by_nl;
        data_by_div = data.replace(/<\/div>/g,'').split(/<[^<>]*>/);
        data_by_nl = data.replace(/<[^<>]*>/g,'').split("\n");
        if(data_by_nl.length > 1)
            data = data_by_nl;
        else
            data = data_by_div;
        if(data[0] === '')
            data.splice(0,1);
        if(name === 'dijkstra'){
            if(data[0] !== '')
                data[0] = data[0] + ' ' + $('#start').val() + ' ' + $('#end').val();
            else
                data[1] = data[1] + ' ' + $('#start').val() + ' ' + $('#end').val();
        }
        data = {
            'name' : name,
            'data' : data,
            '_token' : $('#form_token').val()
        };
        $.ajax({
            url: window.location.href.split('/')[0] + '/algo/',
            contentType: 'application/json',
            data: JSON.stringify(data),
            timeout: 20000,
            type: 'POST'
        }).done(function(data){
            var edges, str1 = "<div>", str2 = "</div>";
            $('#graph_run').html('Run');
            edges = data;
            data = data.join("</div><div>");
            str1 = str1.concat(data, str2);
            for(var i = 0; i < edges.length; i++){
                edges[i].trim();
                edges[i] = {'source': edges[i].split(' ')[0], 'target': edges[i].split(' ')[1]};
            }
            if(name !== 'dijkstra')
                that.highlightEdges(edges);
            $('#highlight_edges').html(str1);
        }).fail(function(xhr, status, error){
            $('#graph_run').html('Run');
            that.raiseError('Algorithm failed to run');
        });
    }

    this.networkGraph = function(name){
        var that = this, data;
        data = {
            'name' : name
        };
        $.ajax({
            url: window.location.href.split('/')[0] + '/graph/',
            data: data
        }).done(function(data){
            var edges, str1 = "<div>", str2 = "</div>";
            edges = data;
            data = data.join("</div><div>");
            str1 = str1.concat(data, str2);
            $('#graph_data').html(str1);
            $('#graph_build').html('Build');
        });
    }

	this.refreshGraph = function() {
		this.constructForceLayout();
		link = container.selectAll('.link')
            .data(force.links())
		    .enter()
            .append('g')
			.attr('class', 'link')
            .attr('id', function(d) { return 'link_' + d.source.id + '_' + d.target.id; })
			.append('line')
			.attr('class', 'link-line')
			.attr('stroke-width', 4)
			.style('stroke', function(d) { return color(d.type); });

		linkTextShadow = container.selectAll(".link")
			.append("text")
			.attr("class", "link-label")
			.attr("font-family", "Arial, Helvetica, sans-serif")
			.style("font", "normal 18px Arial")
            .style('stroke', 'white')
            .style('stroke-width', '2.5')
            .style('opacity', '.9')
			.attr("dy", ".35em")
			.attr("text-anchor", "middle")
			.text(function(d) { return (typeof(d.weight) === undefined) ? '' : d.weight; });

		linkText = container.selectAll(".link")
			.append("text")
			.attr("class", "link-label")
			.attr("font-family", "Arial, Helvetica, sans-serif")
			.attr("fill", "Black")
			.style("font", "normal 18px Arial")
			.attr("dy", ".35em")
			.attr("text-anchor", "middle")
			.text(function(d) { return (typeof(d.weight) === undefined) ? '' : d.weight; });

        node = container.selectAll('.node')
            .data(force.nodes())
            .enter()
            .append('g')
            .attr('class', 'node')
			.on('mouseover', function(d){
                    container.selectAll('#node_' + d.id)
                        .transition()
                        .duration(500)
                        .attr('r', BIG_RAD);
					container.selectAll('.node')
						.transition()
						.duration(500)
						.attr('opacity', function(o){
							return that.neighboring(d.id, o.id) ? 1 : .2;		
						});
					container.selectAll('.link-line')
						.transition()
						.duration(500)
						.attr('opacity', function(o){
							return o.source.id == d.id || o.target.id == d.id ? 1 : .2;
						});
					container.selectAll('.link-label')
						.transition()
						.duration(500)
						.attr('display', function(o){
							return o.source.id == d.id || o.target.id == d.id ? '' : 'none';
						});
				})
			.on('mouseout', function(d){
                    container.selectAll('#node_' + d.id)
                        .transition()
                        .duration(500)
                        .attr('r', SMALL_RAD);
					container.selectAll('.node')
						.transition()
						.duration(500)
						.attr('opacity', 1);
					container.selectAll('.link-line')
						.transition()
						.duration(500)
						.attr('opacity', function(o){
                                var edge = that.findEdge(o.source.id, o.target.id).dom.find('.link-line');
                                if(edge.attr('dulled') != 1)
                                    return 1;
                                else
                                    return .2;
                            });
					container.selectAll('.link-label')
						.transition()
						.duration(500)
						.attr('display', '');
				})
			.call(drag)
            .append("circle")
			.attr("class", "node-circle")
			.attr("r", SMALL_RAD)
			.attr('id', function(d) { return 'node_' + d.id; })
			.style('fill', function(d) { 
                    if(d.group === 1)
                        return '#024dd9';
                    else
                        return '#6c28f7';
                });

        labels = container.selectAll('.node')
            .append('text')
			.attr("class", "node-label")
			.attr("font-family", "Arial, Helvetica, sans-serif")
			.attr("fill", "white")
			.style("font", "normal 18px Arial")
			.attr("dy", ".35em")
			.attr("text-anchor", "middle")
            .text(function(d) { return d.name; });

		force.start();
	};

	this.tick = function(event) {
		container.selectAll('.node-circle').attr("cx", function(d) { return d.x; })
			.attr("cy", function(d) { return d.y; });

		container.selectAll('.link-line').attr('x1', function(d) { return d.source.x; })
			.attr('y1', function(d) { return d.source.y; })
			.attr('x2', function(d) { return d.target.x; })
			.attr('y2', function(d) { return d.target.y; });

        labels.attr("x", function(d) {
                    return d.x;
                })
            .attr("y", function(d) {
                    return d.y;
                });

		linkText.attr("x", function(d) {
					return ((d.source.x + d.target.x)/2 + 15);
				})
			.attr("y", function(d) {
					return ((d.source.y + d.target.y)/2 + 15);
				});

		linkTextShadow.attr("x", function(d) {
					return ((d.source.x + d.target.x)/2 + 15);
				})
			.attr("y", function(d) {
					return ((d.source.y + d.target.y)/2 + 15);
				});
	};

    function dragstarted(d) {
        d3.event.sourceEvent.stopPropagation();
        d3.select(this).classed("dragging", true);
    }

    function dragended(d) {
        d3.select(this).classed("dragging", false);
    }

};

//Create initial graph
var graph = new Graph();

$(document).on('ready', function() {
	var vertex_list = [];
	for(var i = 0; i < 20; i++){
		vertex_list.push({id: i, name: i});
	}
    $('#graph_type').text('Tree');
    prev_text = 'Tree';
    selected_option = 0;
	graph.buildNodes(vertex_list, 'tree');
	graph.refreshGraph();
});

$('#graph_build').on('click', function(){
    var option = $('.graph_type_option').eq(selected_option);
    prev_text = $('#graph_type').text();
    $(this).html(spinner);
    if(option.hasClass('js_generated')){
        var num, type, vertex_list = [];
        num = $('#num_nodes').val();
        type = option.attr('value');
        for(var i = 0; i < num; i++){
            vertex_list.push({id: i, name: i});
        }
        graph.buildNodes(vertex_list, type);
    }else{
        graph.networkGraph(option.attr('value'));
    }
});

$('#graph_visualize').on('click', function(){
    var res = graph.buildGraphFromInput();
    if(res !== 0){
        graph.raiseError('Invalid edge list');
        return false;
    }
    if(graph.inspectLinks().length > EDGE_LIM){
        $('#warning_modal').modal('show');
    }else{
        graph.refreshGraph();
    }
});

$('#continue_visualizing').on('click', function(){
    graph.refreshGraph();
});

$('#graph_highlight').on('click', function(){
    var edges;
    edges = $('#highlight_edges').html().replace(/<\/div>/g,'').replace(/\n/g,'').split(/<div[\s\w="-:;]*>/);
    for(var i = 0; i < edges.length; i++){
        edges[i].trim();
        edges[i] = {'source': edges[i].split(' ')[0], 'target': edges[i].split(' ')[1]};
    }
    graph.highlightEdges(edges);
});

$('#graph_run').on('click', function(){
    var algo = $('#graph_algo').val();
    $('#graph_run').html(spinner);
    graph.algo(algo);
});

$('#graph_algo').on('change', function(){
    if($(this).val() === 'dijkstra')
        $('#start').closest('.row').show();
    else
        $('#start').closest('.row').hide();
});

$('#graph_type').on('focus', function(){
    $('#graph_type_options').show();
    $('#graph_type').text('');
    $('.graph_type_option:icontains("' + $(this).text().trim() + '")').show();
});

$('#graph_type').on('blur', function(){
    if($('#graph_type').text() === '')
        $('#graph_type').text(prev_text);
    $('#graph_type_options').hide();
});

$('.graph_type_option').on('mousedown', function(e){
    $('#graph_type').blur();
    $('#graph_type').text($(this).text());
    selected_option = $(this).index();
    if($(this).attr('value') === 'input'){
        $('.opt').hide();
    }else if($(this).attr('value') === 'custom'){
        $('.opt').show();
        $('.custom_hide').hide();
        $('.custom_opt').show();
    }else if($(this).hasClass('num_fixed')){
        $('.opt').show();
        $('.nx_opt').hide();
        $('.num_opt').hide();
    }else{
        $('.opt').show();
        $('.custom_hide').show();
        $('.custom_opt').hide();
    }
});

$('#graph_type').on('keyup', function(e){
    var options, option;
    if(e.keyCode === 13){ //enter
        if(selected_option !== -1){
            option = $('.graph_type_option').eq(selected_option);
            $('#graph_type').blur();
            $('#graph_type').text(option.text());
            if(option.attr('value') === 'input'){
                $('.opt').hide();
            }else if(option.attr('value') === 'custom'){
                $('.opt').show();
                $('.custom_hide').hide();
                $('.custom_opt').show();
            }else if(option.hasClass('num_fixed')){
                $('.opt').show();
                $('.nx_opt').hide();
                $('.num_opt').hide();
            }else{
                $('.opt').show();
                $('.custom_hide').show();
                $('.custom_opt').hide();
            }
        }
    }else if(e.keyCode === 38){ // up
        selected_option = (selected_option < 1) ? $('.graph_type_option').length - 1 : selected_option - 1;
    }else if(e.keyCode === 40){ //down
        selected_option = (selected_option === $('.graph_type_option').length - 1) ? 0 : selected_option + 1;
    }else{
        $('.graph_type_option').hide();
        $('.graph_type_option:icontains("' + $(this).text().trim() + '")').show();
    }
    options = $('#graph_type_options');
    option = $('.graph_type_option').eq(selected_option);
    $('.graph_type_option').css('background-color','#fff');
    option.css('background-color', '#ddd'); 
    /* out of view bottom */
    if(options.height() < option.position().top + option.outerHeight())
        options.scrollTop(options.scrollTop() + ((option.position().top + option.outerHeight()) - options.height()));
    /* out of view top */
    if(option.position().top < 0)
        options.scrollTop(options.scrollTop() + option.position().top);
});

$('.collapse_toggle').on('click', function(){
    return false;
});

$('.collapse_cont').on('click', function(){
    $($(this).find('a').attr('href')).collapse('toggle');
    if($(this).hasClass('dropup'))
        $(this).removeClass('dropup');
    else
        $(this).addClass('dropup');
});

return graph;

}();
