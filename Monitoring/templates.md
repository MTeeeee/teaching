Kurze Ergänzung zu templates von heute.

Wenn wir z.B. Config-Dateien für prometheus hochladen wollen, welche Variablen haben. Müssen wir ein paar Kleinigkeiten Verändern:

Dazu können wir anstelle einfach nur Dateien mit "copy" hochzuladen auch Dateien aus Templates erstellen.

Dafür können wir einen Ordner erstellen, der parallel zu dem Files Ordner ist und Templates heißt.

Die Config Datei schieben wir nun in diesen Ordner und ergänzen den Dateinahmen um .j2

Im playbook main.yml im Ordner tasks können wir nun den `ansible.builtin.copy` einen Befehl der config abändern zu `ansible.builtin.template` verwenden und den Pfad auf die neue j2 Datei verändern.

Jetzt können wir Variablen in der Config Datei verwenden.