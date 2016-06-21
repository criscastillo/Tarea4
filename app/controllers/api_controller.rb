require 'pg'
require 'rest-client'
require 'json'

class ApiController < ApplicationController

	skip_before_filter  :verify_authenticity_token

	$url = 'http://api.instagram.com/v1/tags/'
	$version = '1.2.0'

	def cantidadPosts(tag, token)
		respuesta = RestClient.get $url + tag + '?access_token=' + token

		puts respuesta.code.to_s

		if respuesta.code == 200
			info = JSON.parse(respuesta)

			total = info["data"]["media_count"]
			puts 'total posts: ' + total.to_s
		else
			total = nil
		end

		return total
	end

	def obtenerPosts(tag, token)
		respuesta = RestClient.get $url + tag + '/media/recent?access_token=' + token

		if respuesta.code == 200
			posts = JSON.parse(respuesta)["data"]
		else
			posts = nil
		end

		return posts
	end

	def informacionPosts(posts)
		if posts == nil
			return nil
		end

		cantidad = posts.length
		respuesta = Array.new(cantidad)

		i = 0
		while i < cantidad do
			info = {:tags => posts[i]["tags"],
				:username => posts[i]["user"]["username"],
				:likes => posts[i]["likes"]["count"],
				:url => posts[i]["images"]["standard_resolution"]["url"],
				:caption => posts[i]["caption"]["text"]
				}

			respuesta[i] = info

			i += 1
		end

		return respuesta
	end

	#tdi-tarea2.herokuapp.com/api/instagram/tag/buscar
	def responder(mensaje)
		url = 'https://yoda.p.mashape.com/yoda?sentence=' + mensaje

		respuesta = RestClient.get url, "X-Mashape-Key" => "6OXU4tEC8EmshPDZFvmPcDreZSB5p1CHRZtjsnvlWWKUKKSgJO", "Accept" => "text/plain"

		return respuesta
	end

	def buscar
		tag = params[:sentence].to_s
		puts 'sentence: ' + tag
		
		respuesta = responder(tag)

		final = {:text =>  respuesta}

		render json: final.to_json, status: 200
	end

end
