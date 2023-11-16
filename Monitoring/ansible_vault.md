# Ansible Vault


## Befehle

Im ersten Schritt wollen wir eine Datei erzeugen mit einer verschlüsselten Nachricht mit dem Befehl:

`ansible-vault create my_vault.yml`

Jetzt Passwort eingeben, dann Passwort noch einmal eingeben zum bestätigen.

Nun wird der default Editor gestartet(Bsp. vi) und es kann eine Nachricht hinterkegt werden die verschlüsselt werden soll. 

Wir können zum Beispiel eine Variable hier hinterlegen:

`secret_message: "my_little_pony"`

Wenn fertig finen wir die Datei jetzt im Ordner, aber wir können den Inhalt nicht lesen. Probieren wir es mit:

`cat my_vault.yml`

Wenn wir uns den Inhalt der cer verschlüsselten Datei ansehen wollen, können wir das mit:

`ansible-vault view my_vault.yml`

Wenn wir diese Datei wieder bearbeiten wollen, dann können wir das mit:

`ansible-vault edit my_vault.yml`

##

Machmal wollen wir auch bereits existierende Dateien verschlüsseln:

erstellen wir zunächst eine neue Datei:

`touch my_vault_2`

Befüllen diese mit einem Editor unserer wahl.

`ansible-vault encrypt my_vault_2`

##
Sollten wir unser Passwort für die Verschlüsselte Datei ändern wollen

`ansible-vault rekey my_vault.yml`

# Ein Playbook mit einem Vault nutzen

Hier ein Demo Playbook, welches einfach nur den Inhalt der Variablen in der Konsole anzeigt:

```yml
---
- name: Example Ansible playbook for Handlers
  hosts: all
  become: yes
  remote_user: ubuntu
  tasks:
  - name: show secret
    debug:
      var: secret_message
```

Eine Möglichkeit ist `--ask-vault-pass`

Nun können wir das Playbook mit folgendem Befehl starten und dabei die verschlüsselte Datei mitgeben.

`ansible-playbook --inventory hosts playbook.yml -e @my_vault.yml --ask-vault-pass`


## Wir können auch ein Passwort aus einer Datei mitgeben.

zunächst erstellen wir eine Datei, welche das Passwort enthält

`echo "my_little_pony" > password`

(Wenn wir ein sicheres Passwort haben wollen können wir auch `openssl rand -base64 2048 > password` verwenden)

Jetzt erstelle ich wieder einen vault mit einer Verschlüsselten Botschaft. Dabei setzte ich die Option --vault-password-file um eine Datei als Passwort festzulegen.

`ansible-vault create secret_variables.yml --vault-password-file=password`

Diese kann ich jetzt wie folgt einsehen:

ansible-vault view secret_variables.yml --vault-password-file=password

Oder wenn wir das Playbook startet wollen:

ansible-playbook --inventory hosts playbook.yml -e @my_vault.yml --vault-password-file=password


## Oder als Umgebungsvariable nutzen

`export ANSIBLE_VAULT_PASSWORD_FILE=<Pfad zur Passwortdatei>`

`ansible-playbook --inventory hosts playbook.yml -e @my_vault.yml`



