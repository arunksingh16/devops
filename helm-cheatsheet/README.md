#  Helm 3 chear sheet 



Check the version of Helm installed
```
helm version
```

Install or upgrade Helm client
```
helm upgrade --install chart-release-1 . --set param1=monitor,param2=bingo --wait --timeout=30m -n namespace-dev

```

Install a Helm chart
```
helm install --name foo stable/mysql
helm install --name path/to/foo
helm install --name foo bar-1.2.3.tgz
helm install --name foo https://example.com/charts/bar-1.2.3.tgz
```

# Helm Repositories

List Helm repositories
```
helm repo list
```

Update list of Helm charts from repositories
```
helm repo update
```


# Searching Helm Charts

List all installed charts
```
helm search
```

Search for a chart
```
helm search foo
```


# Showing Installed Helm Charts

List all installed Helm charts
```
helm ls
```

List all deleted Helm charts
```
helm ls --deleted
```

List installed and deleted Helm charts
```
helm ls --all
```


# Installing/Deleting Helm charts

Inspect the variables in a chart
```
helm inspect values stable/mysql
```


Show status of Helm chart being installed
```
helm status foo
```

# Upgrading Helm Charts

Return the variables for a release
```
helm get values foo
```


List release numbers
```
helm history foo
```

Rollback to a previous release number
```
helm rollback foo 1
```


# Creating Helm Charts

Create a blank chart
```
helm create foo
```

Lint the chart
```
helm lint foo
```

Package the chart into foo.tgz
```
helm package foo
```

Install chart dependencies
```
helm dependency update
```

# Chart Folder Structure

```
wordpress/
  Chart.yaml          # A YAML file containing information about the chart
  LICENSE             # OPTIONAL: A plain text file containing the license for the chart
  README.md           # OPTIONAL: A human-readable README file
  requirements.yaml   # OPTIONAL: A YAML file listing dependencies for the chart
  values.yaml         # The default configuration values for this chart
  charts/             # A directory containing any charts upon which this chart depends.
  templates/          # A directory of templates that, when combined with values,
                      # will generate valid Kubernetes manifest files.
  templates/NOTES.txt # OPTIONAL: A plain text file containing short usage notes
```
