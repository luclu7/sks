# SKS
SSH Key Server

An SSH-accessible key server. You can add/remove your key(s), list every keys on the server and get a specific user's key(s), all via SSH !

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

Copy your server's hostkey:
```bash
cp /etc/ssh/ssh_host_rsa_key hostkey
```

And you're ready to start !
Let's start the server:
```bash
go run main.go
```

Now, connect to it:
```
ssh gui@localhost -p 2222
```

Everything is (technically) working!
