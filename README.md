Connect IQ SDK for Nix
======================

This makes the Connect IQ SDK available as a Nix expression.

Notes
-----

The official [Getting Started](https://developer.garmin.com/connect-iq/programmers-guide/getting-started/)
documentation has details about generating the developer key.

Their [Programmer's Guide](https://developer.garmin.com/connect-iq/programmers-guide/)
has pointers about getting started, in addition to an API doc.

### Building something

```
result/bin/monkeyc -y .../developer_key.der -f result/share/connectiq-sdk/samples/Attention/monkey.jungle -o Attention.prg
```

### Running something

```
# For vivoactive3
result/bin/simulator &
# Wait until the simulator starts
result/bin/monkeydo Attention.prg vivoactive3
```
