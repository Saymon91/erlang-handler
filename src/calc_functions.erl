-module(calc_functions).

-export([median_filter/1, median_filter/2]).

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

build_calibration_list(List) -> build_calibration_list(List, []).

build_calibration_list([], Result) -> Result;
build_calibration_list([First, Next | List], Result) ->
  build_calibration_list(List, Result ++ [[First, Next]]).

find_range(SensorValue, []) -> [];
find_range(SensorValue, [[Sensor1, Value1] | []]) -> [];
find_range(SensorValue, [[Sensor1, Value1], [Sensor2, Value2] | CalibrationList]) ->
  if
    (
      Sensor1 < Sensor2 andalso SensorValue > Sensor1 andalso SensorValue < Sensor2
    ) xor (
      Sensor1 > Sensor2 andalso SensorValue < Sensor1 andalso SensorValue > Sensor2
    ) ->
      [[Sensor1, Value1], [Sensor2, Value2]];
    true -> find_range(SensorValue, [[Sensor2, Value2]] ++ CalibrationList)
  end.

calc_fuel_level(SensorValue, CalibrationList) ->
  FilteredValue = find_range(SensorValue, CalibrationList),
  if
    length(FilteredValue) =:= 0 -> 0;
    true ->
      [[Sensor1, Value1],[Sensor2, Value2]] = FilteredValue,
      K = (Value1 - Value2) / (Sensor1 - Sensor2),
      B = Value2 - K * Sensor2,
      K * SensorValue + B
  end.