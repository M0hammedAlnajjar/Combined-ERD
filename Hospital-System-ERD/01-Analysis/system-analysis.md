# Hospital Management System - System Analysis

## Core entities

| Entity | Purpose | Main attributes |
|---|---|---|
| Patient | Stores patient identity and demographic data | PatientID, NationalID, FirstName, LastName, DOB, BloodGroup, Gender, Address |
| PatientContact | Normalizes multiple phone numbers and emails | ContactID, ContactType, ContactValue, IsPrimary |
| Doctor | Stores professional and employment data | DoctorID, LicenseNo, FirstName, LastName, Specialization, Phone, HireDate, IsActive, DepartureDate |
| Department | Groups doctors and services | DepartmentID, Name, Location |
| Appointment | Schedules one patient with one doctor | AppointmentID, AppointmentDate, AppointmentTime, Status, Type, CancellationReason |
| Service | Defines a healthcare service | ServiceID, Name, Type, CurrentPrice, IsActive |
| AppointmentService | Resolves the Appointment-Service M:N relationship | AppointmentID, ServiceID, Quantity, UnitPriceAtUse, IsBillable |
| ServicePriceHistory | Preserves price validity periods | ServiceID, EffectiveFrom, UnitPrice, EffectiveTo |
| MedicalRecord | Stores the clinical outcome of an appointment | RecordID, Diagnosis, Treatment, CreatedAt |
| Billing | Creates one invoice for an appointment | BillID, IssueDate, Status, TotalAmount |
| Payment | Allows zero, one, or many payments against a bill | PaymentID, Amount, PaidAt, Method, TransactionReference, Status |

## Relationships and cardinalities

| Relationship | Cardinality | Participation |
|---|---|---|
| Department employs Doctor | 1:N | Doctor total; Department may temporarily have no doctors. |
| Doctor heads Department | 0..1 : 0..1 | Optional on both sides to support a vacant head position; head must work in that Department. |
| Department offers Service | 1:N | Service total; Department partial. |
| Patient books Appointment | 1:N | Appointment total; Patient partial. |
| Doctor handles Appointment | 1:N | Appointment total; Doctor partial. |
| Appointment includes Service | M:N | Resolved by AppointmentService; an Appointment may contain zero services. |
| Appointment produces MedicalRecord | 1 : 0..1 | MedicalRecord total; Appointment optional because a cancellation may produce no record. |
| Appointment generates Billing | 1 : 0..1 | Billing total; Appointment optional until charges are finalized. |
| Billing receives Payment | 1:N | Payment total; Billing may have zero payments. |
| Service has PriceHistory | 1:N | PriceHistory total; Service should have at least one effective price before use. |
| Patient has PatientContact | 1:N | Contact total; Patient may have multiple phones/emails. |

## Explicit decisions for undefined rules

1. **Department head:** optional (`0..1`) to allow a new department or temporary vacancy after a doctor leaves. A Doctor may head at most one Department.
2. **Doctor departments:** each Doctor belongs to exactly one Department because the brief uses the singular form. Multi-department affiliation would require a `DoctorDepartment` associative entity.
3. **Appointment without services:** allowed. A consultation or cancelled appointment can exist before services are selected.
4. **Service price changes:** preserved in `ServicePriceHistory`; `AppointmentService.UnitPriceAtUse` snapshots the actual charged price.
5. **Partial payment:** supported through multiple `Payment` rows linked to one Billing record.

