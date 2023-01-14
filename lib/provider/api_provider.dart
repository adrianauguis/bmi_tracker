import 'package:dio/dio.dart';
import 'package:final_bmi/model/test_model.dart';

class TestApiProvider {
  Future<List<TestModel?>> getAllTest() async {
    var url = "https://api.sampleapis.com/presidents/presidents";
    Response response = await Dio().get(url);

    return (response.data as List).map((items) {
      // int stat = items['completed'] == true ? 1 : 0;
      // items['completed'] = stat;
      print('Inserting $items');
      // dbProvider.insertTodo(TodoModel.fromMap(items));

    }).toList();
  }
}