# Test

```sh
make container
export PATH=$PATH:/usr/lib/postgresql/11/bin
# inside the container

# build pglogical
make clean all install

# run the regression tests
su postgres
make regresscheck


# exit
exit
make clean
exit

```
