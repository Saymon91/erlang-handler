-module(calc_functions).

-export([median_filter/2]).

get_median_window(MedianWindow) ->
    DefaultMedianWindow = 3,
    case MedianWindow of
        MedianWindow when MedianWindow < DefaultMedianWindow -> DefaultMedianWindow;
        MedianWindow when MedianWindow rem 2 =:= 0 -> MedianWindow + 1;
        _ -> MedianWindow
    end.

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