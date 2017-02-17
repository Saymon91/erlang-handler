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
-export([hello_world/0, start/0]).
%%%-on_load(init/0).

hello_world() -> io:fwrite("hello, world\n").
init() -> io:fwrite(start()).

get_median_window(MedianWindow) ->
  DefaultMedianWindow = 3,
  case MedianWindow of
    MedianWindow when MedianWindow < DefaultMedianWindow -> DefaultMedianWindow;
    MedianWindow when MedianWindow rem 2 =:= 0 -> MedianWindow + 1;
    _ -> MedianWindow
  end.

median_filter(Arr, MedianWindow) ->
  CorrectMedianWindow = get_median_window(MedianWindow),
  DiffMedian = (CorrectMedianWindow - 1) div 2,
  SourceArray = lists:concat([
    lists:sublist(Arr, 1, DiffMedian),
    Arr,
    lists:sublist(Arr, length(Arr) - DiffMedian, DiffMedian)
  ]),
  StartElementNumber = DiffMedian,
  median_filter_run(SourceArray, DiffMedian, CorrectMedianWindow, StartElementNumber).

median_filter_run(Filtered, DiffMedian, _, ElementNumber)
  when
    (ElementNumber + DiffMedian) > length(Filtered)
  -> lists:sublist(Filtered, DiffMedian + 1, length(Filtered) - DiffMedian - 1);
median_filter_run(Filtered, DiffMedian, MedianWindow, ElementNumber)
  when
    (ElementNumber - DiffMedian) < 0;
    (ElementNumber - DiffMedian) =:= 0
  -> median_filter_run(Filtered, DiffMedian, MedianWindow, ElementNumber + 1);
median_filter_run(Filtered, DiffMedian, MedianWindow, ElementNumber)
  when
    (ElementNumber - DiffMedian) > 0,
    (ElementNumber + DiffMedian) =< length(Filtered)
  ->
  SubArray = lists:sublist(Filtered, ElementNumber - DiffMedian, MedianWindow),
  SortedSubArray = lists:sort(fun (A, B) -> B < A end, SubArray),

  NewFiltered = lists:append([
    lists:sublist(Filtered, 1, ElementNumber - 1),
    lists:sublist(SortedSubArray, DiffMedian + 1, 1),
    lists:sublist(Filtered, ElementNumber + 1, length(Filtered) - ElementNumber)
  ]),
  median_filter_run(NewFiltered, DiffMedian, MedianWindow, ElementNumber + 1).

start() ->
  io:fwrite("start\n"),
  Arr          = [0, 1, 80, 500, 4, 12654, 6, 7, 8, 9, 900],
  MedianWindow = 3,
  Filtered     = median_filter(Arr, MedianWindow),
  io:fwrite("Arr: ~B, Filtered: ~B\n", [length(Arr), length(Filtered)]),
  %%print_list(Filtered),
  io:fwrite("~w~n\n", [Filtered]).

print_list(List) ->
  io:fwrite("List: ["),
  print_list_next(List, 1),
  io:fwrite("\]\n").

print_list_next(List, N) when N =:= length(List) -> io:fwrite("~f", [lists:nth(N, List)]);
print_list_next(List, N) when N < length(List) ->
  io:fwrite("~f, ", [lists:nth(N, List)]),
  print_list_next(List, N + 1).