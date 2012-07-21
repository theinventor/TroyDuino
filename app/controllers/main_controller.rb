class MainController < ApplicationController
  require 'open-uri'

  require 'json'
  TELEDUINO_KEY = "9EB1A6461DE6C8F5BC2999428B9E3D25"


  def index
    base_url = "http://us01.proxy.teleduino.org/api/1.0/328.php?k=#{TELEDUINO_KEY}"
    if params[:three_output]
      query = "&r=definePinMode&pin=3&mode=1"
    elsif params[:three] == "on"
      query = "&r=setDigitalOutput&pin=3&output=1"
    elsif params[:three] == "off"
      query = "&r=setDigitalOutput&pin=3&output=0"
    elsif params[:five_output]
      query = "&r=definePinMode&pin=5&mode=1"
    elsif params[:five] == "on"
      query = "&r=setDigitalOutput&pin=5&output=1"
    elsif params[:five] == "off"
      query = "&r=setDigitalOutput&pin=5&output=0"
    elsif params[:six_output]
      query = "&r=definePinMode&pin=6&mode=1"
    elsif params[:six] == "on"
      query = "&r=setDigitalOutput&pin=6&output=1"
    elsif params[:six] == "off"
      query = "&r=setDigitalOutput&pin=6&output=0"
    elsif params[:seven_output]
      query = "&r=definePinMode&pin=7&mode=1"
    elsif params[:seven] == "on"
      query = "&r=setDigitalOutput&pin=7&output=1"
    elsif params[:seven] == "off"
      query = "&r=setDigitalOutput&pin=7&output=0"

    else
      query = "&r=getUptime"
    end

    @command = base_url + query
    buffer = open(@command, "UserAgent" => "Ruby-Wget").read
    @result = JSON.parse(buffer)
  end

end
