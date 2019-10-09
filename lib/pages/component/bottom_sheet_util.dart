import 'package:flutter/material.dart';
import 'package:workout_helper/general/autocomplete.dart';
import 'package:workout_helper/model/entities.dart';

class MovementBottomSheetUtil {
  List<Movement> suggestions = List();

  MovementBottomSheetUtil(this.suggestions);

  AutoCompleteTextField<Movement> buildMovementSearchBar(
      InputEventCallback<Movement> itemSubmitted,TextEditingController controller) {
    //assert(suggestions.length != 0);
    Movement emptySelection = Movement.empty();
    emptySelection.id = "-1";
    emptySelection.name = "未找到相应的动作，请联系我们添加";
    return AutoCompleteTextField<Movement>(
      itemBuilder: (BuildContext context, Movement suggestion) {
        return ListTile(
            dense: true,
            title: Text(suggestion.name, style: Typography.dense2018.caption));
      },
      emptySelection: emptySelection,
      itemFilter: (Movement suggestion, String query) =>
          suggestion.name == query || suggestion.name.indexOf(query) >= 0,
      suggestions: suggestions,
      itemSorter: (Movement a, Movement b) {
        if(a.name.length != b.name.length){
          return a.name.length.compareTo(b.name.length);
        }
        return a.name.compareTo(b.name);
      },
      clearOnSubmit: false,
      itemSubmitted: itemSubmitted,
      controller: controller,
      decoration: InputDecoration(
          labelText: "训练动作",
          suffixIcon: Icon(Icons.search),
          isDense: true),
    );
  }
}
