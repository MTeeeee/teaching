# Prometheus

In dieser Übung wollen wir uns anschauen wie man Prometheus auf einer EC2 laufen lassen kann.

## 00 EC2 Maschinen erstellen

1. Wir erstellen eine Securitygroup mit den inbound rules: 
- HTTP 80 
- SSH 22
- TCP 3000
- TCP 9090
- TCP 9100

2. Wir erstellen 2 ec2 Instanzen(Ubuntu) und geben Ihnen einen SSH Key mit. Eine prometheus Maschine und eine Maschine die wir kontrollieren beobachten wollen. 


## 01 Prometheus installieren

https://prometheus.io/docs/introduction/first_steps/

1. Wir verbinden uns per SSH/Instance connect zu unserer Prometheus Maschine



2. Wir erstellen einen Ordner und wechseln rein.

```bash
mkdir prometheus
```

```bash
cd prometheus
```



3. Wir suchen die aktuelle Version von Prometheus von der Prometheus Downloadseite raus.
https://prometheus.io/download/

4. Wir kopieren uns den Link zur Linux stable version und laden die Datei in unserer Machine runter. (aktuell: https://github.com/prometheus/prometheus/releases/download/v2.47.2/prometheus-2.47.2.linux-amd64.tar.gz)


```bash
wget https://github.com/prometheus/prometheus/releases/download/v2.47.2/prometheus-2.47.2.linux-amd64.tar.gz
```
5. Datei entpacken `tar xvfz prometheus-*.tar.gz` und in den Ordner wecseln.

```bash
tar xvfz prometheus-2.47.2.linux-amd64.tar.gz
cd prometheus-2.47.2.linux-amd64
```

6. Dort sollte sich nun das Programm fnden, welches wir nun starten können.

```bash
./prometheus
```
7. Standartmäßig nutzt Prometheus den Port 9090.
Wir können nun über den Browser darauf zugreifen.

http://IP-der-EC2:9090

Glückwunsch Prometheus läuft auf dem Server.

## 02 Node Exporter

Nun braucht die Machine noch Daten die abgerufen werden können.
Hierzu müssen wir einen Node Exporter installieren.

0. Wir wechseln wieder auf die Verbindung im Ubuntu Ordner und wollen nun das Programm node exporter installieren.

1. Zunächst Beenden wir Prometheus und suchen die Datei für den prometheus node exporter aus der Doku und installieren Ihn wie zuvor prometheus:

Link zur Datei: https://prometheus.io/download/#node_exporter 

```bash
mkdir node_exporter
cd node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.6.1.linux-amd64.tar.gz
```
2. Nun wechseln wir in den neuen Ordner un starten das Programm.
```bash
cd node_exporter-1.6.1.linux-amd64
./node_exporter
```
Der Standart Port lautet 9100.

3. Wir können nun den Node Exporter über den Browser aufrufen
http://IP-EC2:9100

4. Wir können nun eine zweite Machine genauso mit dem Node Exporter bespielen.

5. Jetzt wollen wir Prometheus so configurieren das alle Daten geladen werden. Auf der Prometheus Maschine im Prometheus Ordner erstellen wir eine `exporter-config.yml` erstellen.

```bash
touch exporter-config.yml
```
6. Diese soll nun wie folgt beschrieben werden:
```bash
nano exporter-config.yml
```
```yml 
global:
   scrape_interval: 15s

scrape_configs:
   - job_name: node
     static_configs:
        - targets: ['localhost:9100','IP-der-EC2-Node:9100'] 
```

7. Nun können wir Prometheus mit der neuen conifg starten:
```bash

./prometheus --config.file=exporter-config.yml

```

## 03 Grafana

Link: https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/

1. 

```bash	
sudo apt-get install -y apt-transport-https software-properties-common wget
```
2. 

```bash	
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```
3. 

```bash	
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```
4. 

```bash	
# Updates the list of available packages
sudo apt-get update
```
5. 

```bash	
# Installs the latest OSS release:
sudo apt-get install grafana
```
6. Nun muss Grafana noch gestartet werden (https://grafana.com/docs/grafana/latest/setup-grafana/start-restart-grafana/)

```bash	
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
```

7. 

```bash	
sudo systemctl enable grafana-server.service
```

Grafana läuft Standart auf Port 3000 und kann nun erreicht werden unter:
http://IP-EC2:3000

8. Logindaten sind zu beginn username: admin password: admin 
Beim ersten Login wird man gebeten das Passwort neu zu vergeben.

9. Mit Grafana rumprobieren.

# Hausaufgabe:
Erstelle diese Übung mit Ansible.