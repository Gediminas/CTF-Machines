# CTF Machines / Environment

CTF (Capture the Flag) is a cyber-security competition that is used to test and develop computer security skills.

```sh
export CTF_ROOT=~/ctf

mkdir -p $CTF_ROOT/boxes
mkdir -p $CTF_ROOT/sync/.config
mkdir -p $CTF_ROOT/sync/.local_share
mkdir -p $CTF_ROOT/sync/work

git clone git@github.com:Gediminas/CTF-Machines.git $CTF_ROOT/machines
cd $CTF_ROOT/machines

./start.sh

  # do things...

./stop.sh
```
