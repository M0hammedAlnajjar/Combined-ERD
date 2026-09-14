# Hospital Management System - Logical Design

## Relational schema

```text
PATIENT(
  PatientID PK,
  NationalID UQ,
  FirstName,
  LastName,
  DOB,
  BloodGroup,
  Gender,
  Address
)

PATIENT_CONTACT(
  ContactID PK,
  PatientID FK -> PATIENT.PatientID NOT NULL,
  ContactType,
  ContactValue,
  IsPrimary,
  UQ (PatientID, ContactType, ContactValue)
)

DEPARTMENT(
  DepartmentID PK,
  Name UQ,
  Location,
  HeadDoctorID FK -> DOCTOR.DoctorID NULL UQ
)

DOCTOR(
  DoctorID PK,
  LicenseNo UQ,
  FirstName,
  LastName,
  Specialization,
  Phone,
  HireDate,
  IsActive,
  DepartureDate,
  DepartmentID FK -> DEPARTMENT.DepartmentID NOT NULL
)

SERVICE(
  ServiceID PK,
  DepartmentID FK -> DEPARTMENT.DepartmentID NOT NULL,
  Name,
  Type,
  CurrentPrice,
  IsActive,
  UQ (DepartmentID, Name)
)

SERVICE_PRICE_HISTORY(
  ServiceID PK/FK -> SERVICE.ServiceID,
  EffectiveFrom PK,
  UnitPrice,
  EffectiveTo NULL,
  CHECK (UnitPrice >= 0),
  CHECK (EffectiveTo IS NULL OR EffectiveTo > EffectiveFrom)
)

APPOINTMENT(
  AppointmentID PK,
  PatientID FK -> PATIENT.PatientID NOT NULL,
  DoctorID FK -> DOCTOR.DoctorID NOT NULL,
  AppointmentDate,
  AppointmentTime,
  Status,
  Type,
  CancellationReason NULL
)

APPOINTMENT_SERVICE(
  AppointmentID PK/FK -> APPOINTMENT.AppointmentID,
  ServiceID PK/FK -> SERVICE.ServiceID,
  Quantity,
  UnitPriceAtUse,
  IsBillable,
  CHECK (Quantity > 0),
  CHECK (UnitPriceAtUse >= 0)
)

MEDICAL_RECORD(
  RecordID PK,
  AppointmentID FK -> APPOINTMENT.AppointmentID NOT NULL UQ,
  Diagnosis,
  Treatment,
  CreatedAt
)

BILLING(
  BillID PK,
  AppointmentID FK -> APPOINTMENT.AppointmentID NOT NULL UQ,
  IssueDate,
  Status,
  TotalAmount
)

PAYMENT(
  PaymentID PK,
  BillID FK -> BILLING.BillID NOT NULL,
  Amount,
  PaidAt,
  Method,
  TransactionReference UQ,
  Status,
  CHECK (Amount > 0)
)
```

## Candidate keys

| Relation | Candidate/alternate key |
|---|---|
| Patient | NationalID |
| Doctor | LicenseNo |
| Department | Name |
| Service | DepartmentID + Name |
| ServicePriceHistory | ServiceID + EffectiveFrom |
| AppointmentService | AppointmentID + ServiceID |
| MedicalRecord | AppointmentID |
| Billing | AppointmentID |
| Payment | TransactionReference |

## Appointment-Service resolution

`Appointment` and `Service` have a genuine M:N relationship. It is resolved by the associative entity `AppointmentService`.

- `Quantity` belongs in `AppointmentService`, not Appointment and not Service, because it describes how many units of one specific Service were used in one specific Appointment.
- `UnitPriceAtUse` also belongs there because it is the price snapshot for that service usage.
- Service usage count is derived with `SUM(AppointmentService.Quantity)` over eligible, non-cancelled appointments.

## Derived values

```text
Patient.Age = completed years from Patient.DOB to current date

Billing.TotalAmount = SUM(
  AppointmentService.Quantity * AppointmentService.UnitPriceAtUse
) WHERE IsBillable = true

AmountPaid = SUM(successful Payment.Amount)

BalanceDue = Billing.TotalAmount - AmountPaid
```

## Participation constraints

- Every Doctor must belong to one Department.
- Every Appointment must reference one Patient and one Doctor.
- Appointment participation in AppointmentService is optional (`0..N`).
- Every AppointmentService row must reference one Appointment and one Service.
- A Department head is optional but, when assigned, must be a Doctor in the same Department.
- A MedicalRecord and a Bill cannot exist without their Appointment.

