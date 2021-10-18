## Python 


### Using Pipenv
When you use `requirements.txt` for managing python packages then it ensures the version of packages which you mentioned in the file. But it ignores the dependencies of that packages.
The real issue here is that the build isn’t deterministic. You can use `pip freeze` to list all dependency versions as well.
Another way to manage dependencies is use `VirtualEnv` but it has also few demerits.

`Pipenv` at this moment is one of the best way to handle python packages. It uses  the Pipfile (which is meant to replace requirements.txt) and the Pipfile.lock (which enables deterministic builds).
Pipenv uses pip and virtualenv under the hood but simplifies their usage with a single command line interface
```
pip install pipenv
```
https://docs.pipenv.org/advanced/#configuration-with-environment-variables
To use pipenv  shell `pipenv shell` 


Let's take an example in which we want to include `kubernetes` package. This will install the package and update the pipenv file.
```
pipenv install kubernetes
```


Providing the --dev argument will put the dependency in a special [dev-packages] location in the Pipfile. These development packages only get installed if you specify the --dev argument with pipenv install.
```
pipenv install pytest --dev
```

Now if you are done with everything then run `pipenv lock`. This will create/update your Pipfile.lock

> Ready to move the code in production. Execute this -
```
# This tells Pipenv to ignore the Pipfile for installation and use what’s in the Pipfile.lock
pipenv install --ignore-pipfile
```

### Creating Python Packages

- Python Packages
- Python disribution Packages
