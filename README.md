# Slackphabet

I am sorry for the name.

### Installing

```bash
$ pub global activate --source git https://github.com/samueljackson-wf/slackphabet
```

### Usage

```
$ pub global run slackphabet "<message>" <color>
```

**Note:** currently this does not write to std-out, and instead copies the output to the clipboard.
Do not use this if you have clipboard data you wish to retain.

The "color" option is optional, and will default to white if omitted.

The supported colors are:
- `--white` (default)
- `--yellow`
- `--alternate`
- `--random`
