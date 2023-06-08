#!/bin/bash

# save
pg_dump -Fc gravitydatasets > gravitydatasets.sql

# restore
# createdb gravitydatasets
# pg_restore gravitydatasets.sql -d gravitydatasets
