# SKS
SSH Key Server

An SSH-accessible key server. You can add/remove your key(s), list every keys on the server and get a specific user's key(s), all via SSH !

You can try it:
```
ssh gui@sks.luc.ovh
```

Installation
---------

First, make sure you have golang installed: it is used for the SSH server itself. SQLite3 and dialog are the other dependencies.
Then, we need to install dependencies:
```bash
go get github.com/gliderlabs/ssh
go get github.com/kr/pty
go get golang.org/x/crypto/ssh
```

Clone the repository:
```bash
git clone https://github.com/luclu7/sks
cd sks
```

Generate a hostkey for the SSH and server and copy the initial database:
```bash
ssh-keygen -b 4096 -t rsa -f hostkey -q -N ""
cp db.sqlite.clean db.sqlite
```

And you're ready to start !
Let's build and start the server:
```bash
go build
./sks
```

Now, connect to it:
```
ssh localhost
```

Everything is (technically) working!
