% components of type 'mult' and 'plus'
comp(c1). comp(c2). comp(c3). comp(c4). comp(c5).
type(c1, mult).
type(c2,mult).
type(c3, mult).
type(c4, plus).
type(c5, plus).


% connections (each gate has two inputs 'inp1', 'inp2' and one output 'out')
conn(x1, inp1(c1)).
conn(x2, inp2(c1)).
conn(x2,inp1(c2)).
conn(x3, inp2(c2)).
conn(x3, inp1(c3)).
conn(x4, inp2(c3)).
conn(out(c1), inp1(c4)).
conn(out(c2), inp2(c4)).
conn(out(c2), inp1(c5)).
conn(out(c3), inp2(c5)).
conn(out(c4), y1).
conn(out(c5), y2).

% we use bounded integer arithmetic (inputs are between 0 and 100)
int(0..100).
mult(X, Y, X*Y) :- int(X), int(Y).
plus(X, Y, X+Y) :- int(X), int(Y).

% multiplication gate (note how also inputs can sometimes be derived)
val(out(C), Z)  :- type(C, mult), nab(C), val(inp1(C), X), val(inp2(C), Y), mult(X, Y, Z).

val(inp1(C), 1) :- type(C, mult), nab(C), val(out(C), 1).
val(inp2(C), 1) :- type(C, mult), nab(C), val(out(C), 1).

val(inp1(C), X) :- type(C, mult), nab(C), val(inp2(C), Y), val(out(C), Z), Z != 0, mult(X, Y, Z).
val(inp2(C), Y) :- type(C, mult), nab(C), val(inp1(C), X), val(out(C), Z), Z != 0, mult(X, Y, Z).

val(inp1(C), 0) :- type(C, mult), nab(C), val(inp2(C), Y), Y != 0, val(out(C), 0).
val(inp2(C), 0) :- type(C, mult), nab(C), val(inp1(C), X), X != 0, val(out(C), 0).

% addition gate
val(out(C), Z)  :- type(C, plus), nab(C), val(inp1(C), X), val(inp2(C), Y), plus(X, Y, Z).
val(inp1(C),X) :- type(C,plus), nab(C), val(inp2(C), Y), val(out(C), Z), Z != 0, plus(X, Y, Z).
val(inp2(C),Y) :- type(C,plus), nab(C), val(inp1(C),X), val(out(C), Z), Z != 0, plus(X, Y, Z).
val(out(C), 0) :- type(C, plus), nab(C), val(inp1(C), 0), val(inp2(C), 0).
val(inp1(C), 0) :- type(C, plus), nab(C), val(inp2(C), Y), val(out(C), Y).
val(inp2(C), 0) :- type(C, plus), nab(C), val(inp1(C), X), val(out(C), X).
val(inp1(C), 0) :- type(C, plus), nab(C), val(out(C), 0).
val(inp2(C), 0) :- type(C, plus), nab(C), val(out(C), 0).

% propagation of values: 
val(P2, V) :- conn(P1, P2), val(P1, V).
val(P1, V) :- conn(P1, P2), val(P2, V).


% integrity constraint (we can't have two values on one part) 
:- val(P,_), #count{ V: val(P, V) } > 1.

% diagnoses of fixed size (search for diagnoses of size 'n')
{ab(C) ; nab(C)} =1 :-comp(C).
#minimize { 1,C: ab(C) }.
% .
% .
%nab(C):-comp(C).
% display (can be changed for debugging purposes)
#show ab/1.
