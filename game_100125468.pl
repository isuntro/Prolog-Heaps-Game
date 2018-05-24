% Author: Tiberiu Simion Voicu
% Sno:  100125468
% Date: 28.11.2017 


% 1.Move_1 will give all the possible combinations
% of moves resulted from taking a stone/stones from any one heap
% 2.Move_2 similar with first one however it calls another predicate remove_n,
% in its base clauses, which removes the same number of stones from another heap.
%----------------------move(+S1,-S2)----------------------
move(S1, S2):- move_1(S1, S2), S2 \= [].
move(S1, S2):- move_2(S1, S2), S2 \= [].

%----------------------First Kind of Move----------------------%
% 1. Remove any number of stone but all from First Pile
% 2. Remove all stones from First Pile
% 3. Remove stones from a subsequent pile 
% move_1(+S1,-S2)
move_1([H|S1], [NewH|S1]):- H1 is H-1,between(1, H1, N), NewH is H - N.
move_1([_|Tail], Tail).
move_1([H|S1], [H|S2]):- move_1(S1, S2).

%----------------------Second Kind of Move----------------------%
% move_2(+S1,-S2)
move_2([H|S1], [NewH|S2]):- H1 is H-1,between(1, H1, N), NewH is H - N, remove_n(S1, S2, N).
move_2([H|Tail], S2):- remove_n(Tail, S2, H).
move_2([H|S1], [H|S2]):- move_2(S1, S2).

% 1.If N = Head of list, remove it and return just the Tail.
% 2.If H > N, remove one from the head and return new state.
% 3.Else remove from another pile
% remove_n(+S,-S2,+N)
remove_n([N|Tail], Tail, N).
remove_n([H|S1], [NewH|S1], N):- H > N, NewH is H - N.
remove_n([H|S1], [H|S2], N):- remove_n(S1, S2, N).

:-dynamic lost/1, won/1, seen/1.
%----------------------Win(+S)----------------------%
win(S):- find_win(S), retractall(lost(_)),retractall(won(_)).
% Produces a depth first search asserting win or loss moves along the path towards the terminal node [1]
% find_win(+S)
find_win(S):- won(S).
find_win(S):- 
        move(S, S1), msort(S1, S2), not(lost(S2)),  % If one of the moves is a losing one skip it
        (
        won(S2);    % it's a winning move -> true 
        find_win(S2) -> assert(lost(S2)), fail ;    % else it's a winning move for the enemey assert assert as lost
        assert(won(S2))                             % otherwise assert as won
        ),!.
find_win([1]):- !,fail. % 1 is a loss -> fail
% Analyse will check if the State S is a winning one,
% if it is it will print all the winning moves, 
% else it will report there are no winning moves
%----------------------Analyse(+S)----------------------%
analyse(S):- write(S),write(" : "), fail.
analyse(S):- not(win(S)), write("No moves"),!, fail.
analyse(S):- setof(S1, move(S, S1), Set),member(S2, Set), not(win(S2)), write(S2),false.
analyse(_).

% Calls analyse on all heaps of 1 or 2 sizes resulted
% from using the generate_n_heaps predicate
%----------------------analyseAll(+S)----------------------%
analyseAll(N):- generate_n_heaps(N, Result),nl,analyse(Result),fail.
analyseAll(_):- retractall(seen(_)).

% Upon backtracking generates all possible game states from 1 to N of size 1 and 2
% Such as for a number N = 2 => [1],[2],[1,1],[1,2],[2,2]
% generate_n_heaps(+N, -Result)
generate_n_heaps(N, Result):-
    between(1, N, Nr), Result = [Nr].
generate_n_heaps(N, Result):-
    between(1, N, Nr), between(1, N, Nr2), msort([Nr,Nr2], Result),not(seen(Result)), assert(seen(Result)).
%----------------------play(+S)----------------------%
play([]):- !,fail.
play([1]):- !, write("You lost"),fail.
play(S):-
    validate_input(S),write("Current State: "), write(S), write(" Choose a move "), nl, get_input(S, NewState),
    (
    NewState = [1] -> write(" You Won "), true;
    ai_move(NewState, AIMove), play(AIMove)
    ).
% Asks the player to input a move and uses validate_input and validate_int predicates 
% to check the validity of the NewState, if the checks fail , it will ask for another input state
get_input(S, NewState):-
    (read(Input), validate_input(Input), validate_move(S, Input), NewState = Input ),!;
    write("Try again"),nl,get_input(S, NewState),!.
% Check if given atom is a list
validate_input(S):-
    is_list(S) -> validate_int(S);
    write("Input state is not a list"),nl, !,fail.
% Check if given list containts only integers higher than 0
% validate_int(+S)
validate_int([]):- !.
validate_int([H|S]):-
    (
        integer(H), H > 0 -> true;
        write("List must contain only integers higher than 0"),nl, !, fail
    ), validate_int(S).
% Validate interactive players input, 
% by checking if it matches any valid
% move made from the initial state S.
% validate_move(+S, -NewState)
validate_move(S, NewState):-
    setof(S1, move(S, S1), Set),
    member(NewState, Set), write("You played: "),write(NewState),nl; 
    write("Your move is invalid"),nl, !, fail.
% Ai will play its best move if there is one,
% if not it will just play any valid move
% ai_move(+S, -NewState)
ai_move(S, NewState):-
    (
        setof(S1,move(S, S1), Set), member(NewState, Set), not(win(NewState)), !
        ;
        move(S, NewState)
    ),!, write("Ai played: "), write(NewState),nl.




    
    