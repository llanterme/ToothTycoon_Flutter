class AddChildPostData{
  String name;
  String dateOfBirth;
  String imagePath;

  Map<String, String> toJson(){
    Map<String, String> data = {
      'name' : this.name,
      'age' : this.dateOfBirth,
      'image' : this.imagePath,
    };

    return data;
  }

}