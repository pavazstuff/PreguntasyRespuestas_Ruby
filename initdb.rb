require 'sqlite3'

if File.exists? "preguntas.sqlite"
	File.delete("preguntas.sqlite")
end

db = SQLite3::Database.open('preguntas.sqlite')

db.execute <<SQL
	CREATE TABLE preguntas(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		pregunta VARCHAR(256),
		contenido TEXT
		);
SQL

db.execute <<SQL
	CREATE TABLE respuestas(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		pregunta INTEGER,
		respuesta TEXT
		);
SQL

db.execute <<SQL
	INSERT INTO preguntas(pregunta, contenido) VALUES
	("como nacen los bebes?", "quiero saber todo al respecto"),
	("porque no puedo hacer nada bien?", "me siento triste porque no logro hacer nada bien"),
	("puedo quedar embarazada?", "la semana pasada lo hice con mi novio"),
	("como actualizo windows 7?", "en que pagina o con que programa puedo hacerlo"),
	("alguien me puede ayudar con mi tarea?", "mi tarea es de algebra x^2*3+7/2");
SQL

db.execute <<SQL
	INSERT INTO respuestas(pregunta, respuesta) VALUES
	(1, "los trae la cigueña desde francia"),
	(1, "buscalo en wikipedia"),
	(2, "que feo ser tu, no me imagino siendo perdedor"),
	(2, "sal adelante veras que puedes hacer las cosas bien"),
	(3, "si"),
	(3, "depende de si usaste preservativos"),
	(4, "dirigite a panel de control y luego a windows update"),
	(4, "es pirata u original?"),
	(5, "NO"),
	(5, "buscalo en buenastareas.com flojo");
SQL

