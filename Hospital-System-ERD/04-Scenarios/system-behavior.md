# Hospital Management System - Behavior Scenarios

## 1. Appointment cancellation

- Do not delete the Appointment.
- Change `Appointment.Status` to `CANCELLED` and store `CancellationReason`.
- Do not create a MedicalRecord unless clinical work actually occurred.
- Existing AppointmentService rows can be retained for audit, with `IsBillable = false` unless a valid cancellation fee applies.
- If a Bill already exists, issue a zero balance, adjustment, or refund record according to hospital policy rather than deleting financial history.

## 2. Doctor leaving the hospital

- Do not delete the Doctor, because historical appointments and medical records must remain traceable.
- Set `Doctor.IsActive = false` and record `DepartureDate`.
- Prevent new appointments for inactive doctors.
- Reassign or cancel future appointments in a controlled transaction.
- If the Doctor is a Department head, clear `HeadDoctorID` and assign a replacement later.
- Use restrictive foreign-key deletion rules for historical clinical records.

## 3. Partial payments

- One Billing record can have many Payment records.
- Each successful payment contributes to `AmountPaid`.
- Billing status is derived/maintained as:
  - `UNPAID` when AmountPaid = 0.
  - `PARTIAL` when 0 < AmountPaid < TotalAmount.
  - `PAID` when AmountPaid = TotalAmount.
  - `OVERPAID` or refund workflow when AmountPaid > TotalAmount.
- Failed or reversed payments remain as records but do not increase AmountPaid.

## 4. Service price changes

- Close the current ServicePriceHistory interval by setting `EffectiveTo`.
- Insert a new row with the new price and its `EffectiveFrom` date.
- Existing AppointmentService rows keep their original `UnitPriceAtUse`.
- New service usage copies the currently effective price into `UnitPriceAtUse`.
- Historical bills therefore never change when the current catalog price changes.

## 5. Safe deletion strategy

- Prefer status fields and end dates over hard deletion for Patient, Doctor, Service, Appointment, Billing, and Payment.
- Use cascade deletion only for truly dependent draft data when no legal/audit record exists.
- Use audit logging for changes to clinical and financial records.

