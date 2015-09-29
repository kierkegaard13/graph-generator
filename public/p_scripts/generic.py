import networkx as nx
import sys

if(len(sys.argv) > 3):
    G = getattr(nx, sys.argv[1])(int(sys.argv[2]), int(sys.argv[3]))
elif(len(sys.argv) > 2):
    G = getattr(nx, sys.argv[1])(int(sys.argv[2]))
else:
    G = getattr(nx, sys.argv[1])()
print(str(G.number_of_nodes()) + ' ' + str(G.number_of_edges()))
for edge in G.edges():
    print(str(edge[0]) + ' ' + str(edge[1]))
