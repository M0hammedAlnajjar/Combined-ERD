# Level 1 - College Logical Design

## Relations

```text
DEPARTMENT(
  Department_id PK,
  D_name
)

FACULTY(
  F_id PK,
  Name,
  Mobile_no,
  Salary,
  Department_id FK -> DEPARTMENT.Department_id NOT NULL
)

HOSTEL(
  Hostel_id PK,
  Hostel_name,
  City,
  State,
  Address,
  Pin_code,
  No_of_seats
)

STUDENT(
  S_id PK,
  F_name,
  L_name,
  Phone_no,
  DOB,
  AdvisorF_id FK -> FACULTY.F_id NULL,
  Department_id FK -> DEPARTMENT.Department_id NULL,
  Hostel_id FK -> HOSTEL.Hostel_id NULL
)

COURSE(
  Course_id PK,
  Course_name,
  Duration,
  Department_id FK -> DEPARTMENT.Department_id NOT NULL
)

SUBJECT(
  Subject_id PK,
  Subject_name,
  Course_id FK -> COURSE.Course_id NOT NULL
)

EXAM(
  Exam_code PK,
  Exam_date,
  Exam_time,
  Room,
  Department_id FK -> DEPARTMENT.Department_id NOT NULL
)

STUDENT_COURSE(
  S_id PK/FK -> STUDENT.S_id,
  Course_id PK/FK -> COURSE.Course_id
)

FACULTY_SUBJECT(
  F_id PK/FK -> FACULTY.F_id,
  Subject_id PK/FK -> SUBJECT.Subject_id
)

STUDENT_SUBJECT(
  S_id PK/FK -> STUDENT.S_id,
  Subject_id PK/FK -> SUBJECT.Subject_id
)

STUDENT_EXAM(
  S_id PK/FK -> STUDENT.S_id,
  Exam_code PK/FK -> EXAM.Exam_code
)
```

## Derived value

`Age = completed years between DOB and CURRENT_DATE`.

Age should be calculated in a query or application layer, not stored as a column.
