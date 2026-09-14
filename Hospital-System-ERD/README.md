# Hospital Management System ERD

## Project overview

This project analyzes and designs a normalized Hospital Management System covering patients, doctors, departments, appointments, healthcare services, medical records, billing, and payments.

## Required submission structure

```text
Hospital-System-ERD/
├── 01-Analysis/
│   ├── system-analysis.md
│   └── design-improvements.md
├── 02-Logical-Design/
│   └── logical-design.md
├── 03-ERD/
│   ├── Hospital_Chen_ERD.drawio
│   ├── Hospital_Chen_ERD.png
│   └── Hospital_Chen_ERD.svg
├── 04-Scenarios/
│   └── system-behavior.md
├── 05-Required-Thinking/
│   └── classification.md
└── README.md
```

## Key design decisions

1. `AppointmentService` resolves Appointment-to-Service M:N.
2. `Quantity` and `UnitPriceAtUse` belong to AppointmentService because they depend on a specific appointment-service pairing.
3. Patient Age, service usage count, paid amount, and balance due are derived values.
4. `Payment` supports partial payments without overwriting earlier transactions.
5. `ServicePriceHistory` and `UnitPriceAtUse` protect historical billing from later price changes.
6. A Department may temporarily have no head; a Doctor may head at most one Department and must belong to it.
7. Appointments can exist with zero services to support consultation, draft, and cancellation workflows.

## Main challenges resolved

- Correctly placing Quantity on the M:N relationship.
- Separating current service price, price history, and charged price snapshot.
- Preserving historical data when appointments are cancelled or doctors leave.
- Supporting partial payments through an auditable transaction entity.
- Normalizing multi-valued patient contact information.

## How to open the ERD

Open `03-ERD/Hospital_Chen_ERD.drawio` in `https://app.diagrams.net/`. Every entity, relationship, attribute, and connector is editable.
