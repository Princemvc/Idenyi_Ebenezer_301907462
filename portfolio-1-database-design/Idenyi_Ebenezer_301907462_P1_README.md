# Portfolio 1 — Database Design and Modelling

I organised the data into candidate, exam, attempt, question, answer. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| candidate | 1 |
| exam | 1 |
| attempt | 2 |
| question | 1 |
| answer | 1 |

The 18 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Idenyi_Ebenezer_301907462_P1_Design.md)
- [ER diagram](Idenyi_Ebenezer_301907462_P1_ERDiagram.md)
- [Normalisation](Idenyi_Ebenezer_301907462_P1_Normalisation.md)
- [Schema](Idenyi_Ebenezer_301907462_P1_Schema.sql)
- [Sample data](Idenyi_Ebenezer_301907462_P1_SampleData.sql)
- [Constraint tests](Idenyi_Ebenezer_301907462_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Idenyi_Ebenezer_301907462_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

