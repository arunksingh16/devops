## Sending Copilot Usage Data to New Relic


# Setting up
```
npm init -y
npm install axios
node index.js
```

# Filter data for 1 day
```
curl -s -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer xxxx" -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/xxx/copilot/usage | jq '.[] | select(.day == "2024-09-12")'
```
