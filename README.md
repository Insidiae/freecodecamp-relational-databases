# freeCodeCamp: Relational Database

This repo contains my project files from freeCodeCamp's Relational Database certification projects.

The `.sql` files are dumped according to the instructions in the Gitpod workspace. Here's a sample command to generate the dump:

```sh
pg_dump -cC --inserts -U freecodecamp universe > universe.sql
```

Here's a sample command to rebuild the database from an existing dump:

```sh
psql -U postgres < universe.sql
```
