modprobe panfrost.ko # in case it wasn't autoloaded

# setup the environment
UID=0
export XDG_RUNTIME_DIR=/tmp/${UID}-runtime-dir
mkdir "${XDG_RUNTIME_DIR}"
chmod 0700 "${XDG_RUNTIME_DIR}"

# start weston
weston --tty=2 --backend=drm-backend.so &
