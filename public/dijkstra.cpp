#include <cmath>
#include <cstdio>
#include <vector>
#include <iostream>
#include <queue>
#include <algorithm>
#include <stdint.h>
using namespace std;

#define pii pair<int64_t,double>
#define INF (1<<30)
#define MAX 100010

int64_t N, M;

struct comp {
    bool operator() (const pii &a, const pii &b) {
        return a.second > b.second;
    }
};

void dijkstra(vector<vector<pii>> G, vector<double>& D, int64_t start, int64_t end = -1){
    int64_t u, v, sz;
    double w;
    priority_queue<pii, vector<pii>, comp> Q;
    vector<int64_t> pred(MAX, -1);
    vector<int> F(MAX, 0);
    for(int i = 0; i < N; i++) D[i] = INF;
    D[start] = 0;
    Q.push(pii(start, 0));

    // dijkstra
    while(!Q.empty()) {
        u = Q.top().first;
        Q.pop();
        if(F[u]) continue;
        sz = G[u].size();
        for(int64_t i = 0; i < sz; i++) {
            v = G[u][i].first;
            w = G[u][i].second;
            if((F[v] != 1) && (D[u] + w < D[v])) {
                D[v] = D[u] + w;
                pred[v] = u;
                Q.push(pii(v, D[v]));
            }
        }
        F[u] = 1; // done with u
    }

    // result
    if(end == -1){
        for(int64_t i = 0; i < N; i++){
            int64_t curr = i;
            printf("Node %ld, min weight = %f\n", i, D[i]);
            printf("Path: \n");
            printf("%ld", curr);
            while(pred[curr] != -1){
                curr = pred[curr];
                printf(" -> %ld", curr);
            }
            printf("\n");
        }
    }else{
        int64_t curr = end;
        printf("Path %ld to %ld, min weight = %f\n", start, end, D[end]);
        while(pred[curr] != -1){
            printf("%ld %ld\n", curr, pred[curr]); 
            curr = pred[curr];
        }
    }
}

int main() {
    /* Enter your code here. Read input from STDIN. Print output to STDOUT */   
    int64_t a, b, start, end;
    double c;
    ios::sync_with_stdio(false);
    vector<vector<pii>> G;
    vector<double> D(MAX,0);
    cin >> N >> M >> start >> end;
    G.assign(MAX,vector<pii>(0,pii(0,0)));
    for(int64_t x = 0; x < M; x++){
        cin >> a >> b >> c;
        G[a].push_back(pii(b,c));
        G[b].push_back(pii(a,c));
    }
    dijkstra(G, D, start, end);
    return 0;
}
