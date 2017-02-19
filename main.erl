%%%-------------------------------------------------------------------
%%% @author semen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Февр. 2017 11:30
%%%-------------------------------------------------------------------
-module(main).
-author("semen").

%% API
-export([start/0]).
%%%-on_load(init/0).

test(List) -> test(List, []).

test([], Result) -> Result;
test([First, Next | List], Result) -> test(List, Result ++ [[First, Next]]).

get_default_median_filter() -> 3.
get_median_window(Window) ->
  DefaultMedianWindow = get_default_median_filter(),
  case Window of
    Window when Window < DefaultMedianWindow -> DefaultMedianWindow;
    Window when Window rem 2 =:= 0 -> Window + 1;
    _ -> Window
  end.

median_filter(List) -> median_filter(List, get_default_median_filter()).
median_filter(List, Window) ->
  CorrectWindow = get_median_window(Window),
  Diff = (CorrectWindow - 1) div 2,
  SourceList =
    lists:sublist(List, 1, Diff) ++
    List ++
    lists:sublist(List, length(List) - Diff, Diff),
  StartIndex = Diff,
  median_filter(SourceList, Diff, CorrectWindow, StartIndex).

median_filter(List, Diff, _, Index) when (Index + Diff) > length(List) ->
  lists:sublist(List, Diff + 1, length(List) - Diff - 1);
median_filter(List, Diff, Window, Index) when (Index - Diff) < 0; (Index - Diff) =:= 0 ->
  median_filter(List, Diff, Window, Index + 1);
median_filter(List, Diff, Window, Index) when (Index - Diff) > 0, (Index + Diff) =< length(List) ->
  SubList = lists:sublist(List, Index - Diff, Window),
  SortedSubList = lists:sort(fun (Prev, Next) -> Next < Prev end, SubList),

  NewFiltered =
    lists:sublist(List, 1, Index - 1) ++
    lists:sublist(SortedSubList, Diff + 1, 1) ++
    lists:sublist(List, Index + 1, length(List) - Index),
  median_filter(NewFiltered, Diff, Window, Index + 1).

start() ->
  Result = test([1,2,3,4,5,6,7,8]),
  io:fwrite("~p~n", [Result]),
  Result1 = median_filter([1, 2, 3, 100, 2, 50, 34, 10, 7, 8]),
  io:fwrite("~p~n", [Result1])
.