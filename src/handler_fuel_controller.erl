%%%-------------------------------------------------------------------
%%% @author semen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Февр. 2017 11:30
%%%-------------------------------------------------------------------
-module(handler_fuel_controller).
-author("semen").

%% API
-export([hello_world/0, start/0]).
%%%-on_load(init/0).

hello_world() -> io:fwrite("hello, world\n").
init() -> io:fwrite(start()).

median_filter(Arr, MedianWindow) ->
  io:fwrite("median_filter\n"),
  io:fwrite("Median: ~B\n", [MedianWindow]),
  io:fwrite("Calc diff\n"),
  DiffMedian = (MedianWindow - 1) div 2,
  io:fwrite("Diff ~B\n", [DiffMedian]),
  median_filter_run(Arr, DiffMedian, [], 1).

median_filter_run(Arr, _, Filtered, ElementNumber) when ElementNumber > length(Arr) ->
  io:fwrite("1\n"),
  Filtered;
median_filter_run(Arr, MedianWindow, Filtered, ElementNumber)
  when
    (ElementNumber - MedianWindow) < 0;
    (ElementNumber - MedianWindow) =:= 0
  ->
  io:fwrite("2\n"),
  median_filter_run(Arr, MedianWindow, Filtered, ElementNumber + 1);
median_filter_run(Arr, MedianWindow, Filtered, ElementNumber)
  when
    (ElementNumber - MedianWindow) > 0,
    (ElementNumber + MedianWindow) < length(Arr)
  ->
  io:fwrite("3\n"),

  PrevNumber  = ElementNumber - MedianWindow,
  NextNumber  = ElementNumber + MedianWindow,
  PrevElement = element(PrevNumber, Arr),
  NextElement = element(NextNumber, Arr),
  SetElement = (PrevElement + NextElement) / 2,
  io:fwrite("PrevElement: ~B, NextElement: ~B, SetElement: ~B\n", [PrevElement, NextElement, SetElement]),

  setelement(ElementNumber, Filtered, SetElement),
  median_filter_run(Arr, MedianWindow, Filtered, ElementNumber + 1).

start() ->
  io:fwrite("start\n"),
  Arr          = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ,10],
  MedianWindow = 3,
  Filtered     = median_filter(Arr, MedianWindow),
  Filtered.
  %%%length(Filtered).