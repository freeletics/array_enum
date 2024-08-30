1.6.0
----------
- Bump Rails related dependencies to 7.2 (#23)
- Cast appropriate type when generating where query. (#22)

1.5.0
----------
 - Fix the PG::AmbiguousColumn error when we do a join and filter on 2 tables that has the same array_enum column name. (#19)
 - Drop Ruby 2.7 support (#19)
