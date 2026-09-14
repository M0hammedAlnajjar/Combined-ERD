# Hospital Management System - Mandatory Classification

| Item | Classification | Reason |
|---|---|---|
| Patient | Strong entity | Has its own identifier and exists independently of appointments. |
| PatientID | Key attribute | Uniquely identifies a Patient. |
| NationalID | Candidate key attribute | Can uniquely identify a Patient when present and validated. |
| Patient Name | Composite attribute | Split into FirstName and LastName. |
| DOB | Stored attribute | Stable source value used to calculate age. |
| Age | Derived attribute | Changes over time and is calculated from DOB. |
| Patient phone/email collection | Multi-valued attribute conceptually | A Patient can have several contact values; normalized into PatientContact. |
| BloodGroup | Simple attribute | One atomic demographic value. |
| Gender | Simple attribute | One atomic demographic value. |
| PatientContact | Strong child entity | Uses ContactID and normalizes repeated contact values. |
| Doctor | Strong entity | Has its own DoctorID and persists independently of a specific appointment. |
| DoctorID | Key attribute | Uniquely identifies a Doctor. |
| LicenseNo | Candidate key attribute | Professional registration number should be unique. |
| Specialization | Simple attribute | Describes the Doctor's professional area. |
| IsActive and DepartureDate | Status/history attributes | Preserve a Doctor's historical identity after leaving. |
| Department | Strong entity | Has its own DepartmentID. |
| DepartmentID | Key attribute | Uniquely identifies a Department. |
| Department Name | Candidate key attribute | Business name is required to be unique in this design. |
| WORKS_IN | 1:N relationship | One Department contains many Doctors; each Doctor works in one Department. |
| HEADS | Optional 1:1 relationship | A Department may temporarily have no head; a Doctor heads at most one Department. |
| Service | Strong entity | Has ServiceID and can be defined before an appointment uses it. |
| ServiceID | Key attribute | Uniquely identifies a Service. |
| Service Name and Type | Simple attributes | Describe the service catalog item. |
| CurrentPrice | Stored/cache attribute | Convenient current catalog value; authoritative history is held separately. |
| OFFERS | 1:N relationship | A Department offers many Services; each Service belongs to one Department. |
| ServicePriceHistory | Weak/existence-dependent entity | A price period cannot exist without its Service; identified by ServiceID and EffectiveFrom. |
| EffectiveFrom | Partial key attribute | Distinguishes price periods within one Service. |
| Appointment | Strong/transaction entity | Has AppointmentID and links one Patient with one Doctor. |
| AppointmentID | Key attribute | Uniquely identifies an Appointment. |
| Appointment date, time, status, type | Simple attributes | Describe scheduling and lifecycle state. |
| BOOKS | 1:N relationship | One Patient can book many Appointments; each Appointment has one Patient. |
| HANDLES | 1:N relationship | One Doctor handles many Appointments; each Appointment has one Doctor. |
| Appointment-Service | M:N relationship | One Appointment can use many Services and one Service can occur in many Appointments. |
| AppointmentService | Associative/weak entity | Resolves the M:N relationship and depends on both parent entities. |
| AppointmentID + ServiceID | Composite key | Uniquely identifies one service type within an appointment. |
| Quantity | Relationship attribute | Depends on the Appointment-Service pair, not on either entity alone. |
| UnitPriceAtUse | Relationship attribute/snapshot | Captures the price used for this service in this appointment. |
| ServiceUsageCount | Derived attribute | Calculated by summing Quantity across eligible AppointmentService rows. |
| MedicalRecord | Existence-dependent entity | Cannot exist without the Appointment that produced it. |
| Diagnosis and Treatment | Simple attributes | Store the clinical result. |
| PRODUCES | 1:0..1 relationship | An Appointment may produce one MedicalRecord; cancellation may produce none. |
| Billing | Existence-dependent entity | Created for one Appointment and has no independent business meaning. |
| TotalAmount | Derived/snapshotted attribute | Calculated from billable AppointmentService rows; may be frozen on issue. |
| GENERATES | 1:0..1 relationship | An Appointment may generate one Bill. |
| Payment | Strong transaction entity | Has PaymentID and must remain auditable even if later reversed. |
| PaymentID | Key attribute | Uniquely identifies a payment attempt/transaction. |
| Payment Amount, Method, PaidAt, Status | Simple transaction attributes | Describe each payment event. |
| RECEIVES | 1:N relationship | One Bill can receive multiple Payments, supporting partial payment. |
| AmountPaid | Derived attribute | Sum of successful Payment amounts. |
| BalanceDue | Derived attribute | TotalAmount minus AmountPaid. |

## Strong and weak summary

- Strong entities: Patient, PatientContact, Doctor, Department, Service, Appointment, Payment.
- Associative entity: AppointmentService (identified by its two parent keys).
- Weak entity: ServicePriceHistory (identified by Service plus the partial key EffectiveFrom).
- Existence-dependent entities with their own identifiers: MedicalRecord and Billing.
