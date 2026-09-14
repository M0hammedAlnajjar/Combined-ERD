# Hospital System - Design Improvements

1. **Separate patient contacts** into `PatientContact` so one patient can store several phone numbers, email addresses, or emergency contacts without repeating patient data.
2. **Resolve Appointment-Service M:N** with `AppointmentService`. `Quantity` and `UnitPriceAtUse` belong to this bridge because both depend on one specific appointment and one specific service.
3. **Preserve price history** in `ServicePriceHistory`. Existing bills use the price snapshot in `AppointmentService`, so changing `Service.CurrentPrice` never changes historical charges.
4. **Separate bills and payments**. One bill may receive many payments, which supports deposits and partial payment without adding repeated payment columns to `Billing`.
5. **Use status fields instead of deletion** for cancelled appointments, inactive services, and departed doctors. Historical medical and financial records therefore remain valid.
6. **Keep one medical record and one bill per appointment** through unique foreign keys. Both are optional until the relevant workflow creates them.
7. **Use stable identifiers and alternate keys**: surrogate primary keys for operational joins, with `NationalID`, `LicenseNo`, and `TransactionReference` retained as uniqueness constraints.

## Important validation rules

- A department head must be an active doctor assigned to that same department.
- New appointments cannot be assigned to an inactive doctor.
- The sum of successful payments cannot exceed the bill balance unless the application explicitly supports credit/refunds.
- A service usage row must keep its original `UnitPriceAtUse`, even after a future price change.
- A cancelled appointment remains stored; billable services must be reviewed or reversed instead of deleting the appointment.
