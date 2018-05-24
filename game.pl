
move(S1, S2):- make_move_1(S1, S2).
% 1. Remove all elements from first pile
% 2. Remove some but not all from first pile
% 3. Remove from another pile
% make_move_1([], []):- !.
make_move_1([_|Tail], Tail).
make_move_1([H|S1], [NewH|S1]):- H1 is H-1,between(1, H1, N), NewH is H - N.
make_move_1([H|S1], [H|S2]):- make_move_1(S1, S2).

remove_n([_|[]], [], _):- fail, !.
remove_n([N|Tail], Tail, N):- !.
remove_n([H|S1], [NewH|S1], N):- H > N, NewH is H - N.
remove_n([H|S1], [H|S2], N):- remove_n(S1, S2, N).


make_move_2(S1, [H|S2], N):- remove_n(S1, [H|S3], N), remove_n(S3, S2, N).
% make_move_2()
win(S).