# Rails + Neo4j Demo

A demo using Neo4j to store & query a Git repo history...

```
# Build & start the thing:
plis build && plis start && plis logs -f

# Import the history data from a repo (will clone & pull inside tmp)
plis run web rails demo:import[https://github.com/IcaliaLabs/alpha.git]
```
