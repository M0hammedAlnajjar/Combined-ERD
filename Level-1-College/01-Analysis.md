# Level 1 - College Management System Analysis

## Entities and attributes

| Entity | Primary key | Other attributes | Special attributes |
|---|---|---|---|
| Faculty | F_id | Name, Mobile_no, Salary | Department is modeled as a relationship, not duplicated as text |
| Student | S_id | Name, F_name, L_name, Phone_no, DOB | Name is composite; Age is derived from DOB |
| Hostel | Hostel_id | Hostel_name, City, State, Address, Pin_code, No_of_seats | - |
| Course | Course_id | Course_name, Duration | - |
| Subject | Subject_id | Subject_name | - |
| Exam | Exam_code | Date, Time, Room | - |
| Department | Department_id | D_name | - |

## Relationships and cardinalities

| Relationship | Cardinality | Participation and meaning |
|---|---|---|
| Department employs Faculty | 1:N | Every Faculty member works in one Department; a Department may have many Faculty members. |
| Faculty advises Student | 1:N | The brief's “take care of students” is modeled as advising: a Faculty member may advise many Students; a Student may have zero or one advisor. |
| Department has Student | 1:N | A Student may belong to zero or one Department; a Department may have many Students. |
| Department handles Course | 1:N | Every Course is handled by one Department. |
| Department conducts Exam | 1:N | Every Exam is conducted by one Department. |
| Hostel houses Student | 1:N | Hostel residence is optional for a Student; each resident is assigned to one Hostel. |
| Student enrolls in Course | M:N | A Student can enroll in many Courses and each Course can contain many Students. |
| Course contains Subject | 1:N | Assumption: each Subject belongs to one Course; a Course can contain many Subjects. |
| Faculty teaches Subject | M:N | Faculty can teach many Subjects, and a Subject may be taught by multiple Faculty members. |
| Student takes Subject | M:N | Students can take many Subjects and each Subject can be taken by many Students. |
| Student takes Exam | M:N | A Student can take many Exams and each Exam can be taken by many Students. |

## Design decisions

1. `Student.Name` is a composite attribute made from `F_name` and `L_name`; it is not stored three times.
2. `Student.Age` is derived from `DOB` and the current date; storing it would become inaccurate.
3. The Faculty description lists Department as an attribute, but because Department is an entity, it is represented by the `WORKS_IN` relationship.
4. The brief's “take care of students” is represented by the direct `ADVISES` relationship. Teaching remains represented through `Faculty -> Subject <- Student`, avoiding a duplicate direct teaching fact.
5. The brief does not explicitly connect Course and Subject. This solution assumes a Course contains Subjects so that Subject is not isolated from the academic structure.
