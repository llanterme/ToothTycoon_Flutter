class AddChildPostData{
  late String name;
  late String dateOfBirth;
  late String imagePath;

  Map<String, String> toJson(){
    Map<String, String> data = {
      'name' : name,
      'age' : dateOfBirth,
      'image' : imagePath,
    };

    return data;
  }

}