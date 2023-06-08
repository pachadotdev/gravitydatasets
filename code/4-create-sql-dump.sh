#!/bin/bash

# save
pg_dump -Fc gravitydatasets > gravitydatasets.sql

# restore
# pg_restore gravitydatasets.sql -d gravitydatasets_test.sql
