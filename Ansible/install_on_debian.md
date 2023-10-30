# 0 
check out: https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-debian

# 1

1. Suche die Datei '/etc/apt/sources.list' oder '/etc/apt/sources.list.d/ansible.list'

Ergänze um die Zeile und tausche `focal` durch die passende Version bei dir aus

`deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main`


2. Führe die Befehle aus:

```bash
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
$ sudo apt update
$ sudo apt install ansible
```

Arbeite ab jetzt immer als root user (`sudo su`)

3. Führe nun folgenden Befehl aus:

```bash 
nano /etc/default/locale
```

4. Füge die Zeilen ein:

`LANG=en_US.UTF-8` 
und
`LC_ALL=en.US.UTF-8`

5. Nun führe den Befehl aus:

```bash 
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
```

6. Konsole neu starten (schließen und neu öffnen)

teste mit `sudo su` dann `ansible --version`

Ab hier sollte es wie in der restlichen Anleitung laufen.

# 2 

1. Führe den Befehl aus:

```bash
ssh-keygen -t rsa
cat /root/.ssh/id_rsa.pub
```

2. key rauskopieren und in die ec2 instanz posten mit: 
```bash
sudo su
nano /home/ec2-user/.ssh/autorized_keys
```

3. In der controll node(local)

```bash
sudo nano /etc/ansible/hosts
```
und folgendes einfügen: 
```txt
[demo]
<ip-der-ec2> ansible_user=ec2-user
```

4. jetzt (immernoch als root):
```bash 
ansible demo -m ping 
```