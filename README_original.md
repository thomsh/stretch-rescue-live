__Build Instructions__

Use Debian 9.0 ("stretch"), or newer as the build host.

Ensure you have `sudo` capability to run programs as root.

Install the following packages:
  - `live-build`
  - `apt-cacher-ng`

Create `/etc/live/build.conf` with the following content:

```
LB_APT_HTTP_PROXY="http://localhost:3142/"
```

If you have at least 8 GB of RAM available, mount a `tmpfs`
of size 8 GB or larger on which to run the build. E.g.:

```
mkdir -p "$HOME/mybuild"
sudo mount -t tmpfs -o size=8G tmpfs "$HOME/mybuild"
```

Clone the project into the build directory. E.g.:

```
mkdir -p "$HOME/mybuild"
cd "$HOME/mybuild"
git clone https://salsa.debian.org/smonaica-guest/${project}.git
```

Run the build script as root.

```
cd "$HOME/mybuild/$project"
sudo http_proxy="http://localhost:3142/" ./make.sh
```

