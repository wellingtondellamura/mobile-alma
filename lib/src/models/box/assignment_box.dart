import 'package:alma/src/models/assignment/assignment_type.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AssignmentBox {
  AssignmentBox({
    this.id,
    this.assignmentId,
    this.title,
    this.description,
    this.file,
    this.answer,
    this.hiddenText,
    this.kind,
  });

  int? id;
  int? assignmentId;
  String? title;
  String? description;
  String? file;
  String? answer;
  String? hiddenText;
  AssignmentType? kind;
}
