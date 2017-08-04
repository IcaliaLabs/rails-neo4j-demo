# Rails + Neo4j Demo

A demo using Neo4j to store & query a Git repo history...

```
# Build & start the thing:
plis build && plis start && plis logs -f

# Run the "migrations" on Neo4j database:
plis run web rails neo4j:migrate:all

# Import the history data from a repo (will clone & pull inside tmp)
plis run web rails demo:import[https://github.com/IcaliaLabs/alpha.git]
```

Once finished importing the data, you'll want to check out the database
browser at http://localhost:7474
