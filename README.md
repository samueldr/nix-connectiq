Connect IQ SDK for Nix
======================

This makes the Connect IQ SDK available as a Nix expression.

Building and running a sample
-----------------------------

```
$ nix-build -I developer_key.der=../developer_key/developer_key.der \
	./samples.nix -A Attention

$ nix-shell

# Starts the simulator... it takes a couple seconds to show up
$ simulator &

# Wait until the simulator starts
$ result/bin/monkeydo result/Attention.prg vivoactive3
```

Notes
-----

The official [Getting Started](https://developer.garmin.com/connect-iq/programmers-guide/getting-started/)
documentation has details about generating the developer key.

Their [Programmer's Guide](https://developer.garmin.com/connect-iq/programmers-guide/)
has pointers about getting started, in addition to an API doc.

### Manually building something

```
$ nix-shell
$ monkeyc -y ../developer_key/developer_key.der \
	-f $SDK_PATH/samples/Attention/monkey.jungle \
	-o Attention.prg
```

### Running something

```
$ nix-shell

# Starts the simulator... it takes a couple seconds to show up
$ simulator &

# Wait until the simulator starts, then run
$ monkeydo Attention.prg vivoactive3
```
