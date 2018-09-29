require 'sinatra'
require 'haml'
require 'sqlite3'

class Preguntas
	def initialize()
		@db = SQLite3::Database.open('preguntas.sqlite')
	end

	def portada()
		self.portada_to_hash(@db.execute("SELECT * FROM preguntas"))
	end

	def seleccion_de_pregunta(arr)
		self.portada_to_hash(@db.execute("SELECT * FROM preguntas WHERE id = '#{arr}'"))
	end

	def seleccion_de_respuestas(arr)
		self.seleccion_preg_to_hash(@db.execute("SELECT preguntas.id, preguntas.pregunta, preguntas.contenido, respuestas.respuesta FROM preguntas LEFT OUTER JOIN respuestas ON respuestas.pregunta = preguntas.id WHERE preguntas.id = #{arr}"))
	end

	def nueva_respuesta(arr, respuesta)
		@db.execute("INSERT INTO respuestas(pregunta, respuesta) VALUES('#{arr}', '#{respuesta}')")
		self.seleccion_de_respuestas(arr)
	end

	def nueva_pregunta(pregunta, contenido)
		@db.execute("INSERT INTO preguntas(pregunta, contenido) VALUES('#{pregunta}', '#{contenido}')")
		@db.last_insert_row_id()
	end

	def portada_to_hash(arr)
		arr.map do |dato|
			{
				:id => dato[0],
				:pregunta => dato[1],
				:contenido => dato[2]
			}
		end
	end

	def seleccion_preg_to_hash(arr)
		arr.map do |dato|
			{
				:id => dato[0],
				:pregunta => dato[1],
				:contenido => dato[2],
				:respuesta => dato[3]
			}
		end
	end
end

db = Preguntas.new()

get '/' do
	@preguntas = db.portada()
	haml :index
end

get '/pregunta' do
	if params.has_key?('id')
		@titulopregunta = db.seleccion_de_pregunta(params['id'])
		@conteo = @titulopregunta.count
		if @conteo > 0
			@preguntayrespuestas = db.seleccion_de_respuestas(params['id'])
			haml :question
		else
			redirect "/"
		end
	else
		redirect "/"
	end
end

post '/pregunta' do
	if params.has_key?('respuesta')
		@result = db.nueva_respuesta(params[:id], params[:respuesta])
		id = @result[0][:id]
		redirect "/pregunta?id=#{id}"
	else
		redirect "/"
	end
end

get '/nuevo' do
	haml :nuevo
end

post '/nuevo' do
	if params.has_key?('pregunta') and params.has_key?('contenido')
		id = db.nueva_pregunta(params[:pregunta], params[:contenido])
		redirect "/pregunta?id=#{id}"
	else
		redirect "/"
	end
end

get '/acercade' do
	haml :acercade
end