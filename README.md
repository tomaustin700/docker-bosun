docker run -d -p 4242:4242 -p 8070:8070 --net=host --privileged --name=bosun \
  -v /data0/code/bosun/dev/supervisord.conf:/etc/supervisor/conf.d/supervisord.conf \
  -v /data0/code/bosun/dev/bosun.toml:/data/bosun.toml \
  paladintyrion/bosun:0.7.0
